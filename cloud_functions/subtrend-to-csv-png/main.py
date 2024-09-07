import functions_framework

import ast
import numpy as np
import pandas as pd
import scipy.cluster.hierarchy as hac
import matplotlib.pyplot as plt
from scipy.cluster.hierarchy import fcluster
from scipy.spatial.distance import pdist
from scipy.stats import percentileofscore
from scipy.stats import norm
from sklearn.metrics import silhouette_samples, silhouette_score
from sklearn.cluster import KMeans
import math
import json

# Plot to PNG
import io
import base64

# Chinese font
import matplotlib.font_manager as fm
import subprocess
import urllib.parse
from urllib.parse import quote

# Displot
import seaborn as sns
# sns.set_theme()

buffer = io.BytesIO() # Create the buffer

@functions_framework.http
def https(request):
    if request.method == 'POST':
        if 'sub_trend' in request.form:
            sub_trend = str(request.form['sub_trend'])
            # print(sub_trend)
        else:
            return 'sub_trend parameter is missing in the form data'
        if 'lang' in request.form:
            lang = str(request.form['lang'])
            # print(lang)
        else:
            return 'lang parameter is missing in the form data'
        if 'access_token' in request.form:
            access_token = str(request.form['access_token'])
            # print(access_token)
        else:
            return 'access_token parameter is missing in the form data'
        if 'min_value' in request.form:
            min_value = float(request.form['min_value'])
            # print(min_value)
        else:
            return 'min_value parameter is missing in the form data'
        if 'max_value' in request.form:
            max_value = float(request.form['max_value'])
            # print(max_value)
        else:
            return 'max_value parameter is missing in the form data'
    else:
        return 'POST method is required'

    # Download the font file
    object_name = 'NotoSansTC-Regular.ttf'
    bucket_name = 'notosanstc'
    encoded_bucket_name = quote(bucket_name)
    encoded_object_name = quote(object_name)
    font_curl_command = f'''curl -X GET --http1.1 \
                            -H "Authorization: Bearer {access_token}" \
                            "https://storage.googleapis.com/storage/v1/b/{encoded_bucket_name}/o/{encoded_object_name}?alt=media"'''
    # Execute the cURL command using subprocess
    try:
        response = subprocess.run(font_curl_command, capture_output=True, shell=True, timeout=15)
        # Get the output from the command output
        output = response.stdout
        error = response.stderr
        if response.returncode != 0:
            # print((f'font_curl_command: {error}', 500))
            return f'font_curl_command: {error}', 500
        else:
            with open(object_name, 'wb') as file:
                file.write(output)
            # Add the downloaded font file to the font manager
            fm.fontManager.addfont(object_name)
            # Set the font family globally
            plt.rcParams['font.family'] = 'Noto Sans TC'
    except subprocess.TimeoutExpired:
        # Handle the case when the command exceeds the timeout
        return 'font_curl_command execution timed out!', 500
    
    sub_trend = sub_trend.strip("'")  # Remove single quotes around the string
    subsequent_trends = ast.literal_eval(sub_trend)
    timeSeries = pd.DataFrame(subsequent_trends)

    # Check for non-finite values
    if not np.all(np.isfinite(timeSeries)):
        # Identify non-finite values
        non_finite_mask = ~np.isfinite(timeSeries)
        non_finite_values = timeSeries[non_finite_mask]
        # Print non-finite values
        print("Non-finite values found in the data:")
        print(non_finite_values)
        # Handle non-finite values
        timeSeries = timeSeries.replace([np.inf, -np.inf], np.nan).dropna()

    # Verify data after handling non-finite values
    if timeSeries.empty or not np.all(np.isfinite(timeSeries)):
        print('Data contains non-finite values even after cleanup.')
        return 'Data contains non-finite values even after cleanup.', 400
    #################################################################################################################################################################
    Z = hac.linkage(timeSeries, method='complete', metric='correlation') # Perform 1st clustering

    # Plot dendogram
    plt.figure(figsize=(7, 5))
    if lang == 'zh':
        plt.title('層次聚類樹狀圖')
        plt.xlabel('樣本索引')
        plt.ylabel('距離')
    else:
        plt.title('Hierarchical Clustering Dendrogram')
        plt.xlabel('Sample Indices')
        plt.ylabel('Distance')
    dendrogram = hac.dendrogram(
        Z,
        leaf_rotation=90.,  # rotates the x axis labels
        leaf_font_size=8.,  # font size for the x axis labels
    )
    plt.savefig(buffer, format='png') # Save the plot to the buffer as PNG
    plt.clf() # Clear the current figure
    plt.close() # Close the figure
    image_data1 = base64.b64encode(buffer.getvalue()).decode('utf-8') # Convert the buffer content to base64
    buffer.seek(0) # Reset the buffer position
    
    # Cluster number optimization
    sse = [] # 初始化一个列表用于存储不同k值的SSE（误差平方和）值
    silhouette_scores = [] # 初始化一个列表用于存储不同k值的轮廓分数
    # 定义一个k值的范围进行尝试
    if len(timeSeries) <= 10: # Avoid insufficient of cluster number
        minRange = 2
    else:
        minRange = 3
    k_values = range(minRange, min(len(timeSeries) - 1, 11))
    # 对于k值范围内的每一个k，执行以下操作
    for k in k_values:
        # 使用k个聚类中心初始化KMeans模型
        kmeans = KMeans(n_clusters=k, n_init='auto')
        kmeans.fit(Z)  # 对数据集X进行拟合
        # 计算并添加当前k值的SSE （Elbow（唔洗理））
        sse.append(kmeans.inertia_)
        # 计算并添加当前k值的轮廓分数
        silhouette_avg = silhouette_score(Z, kmeans.labels_)
        silhouette_scores.append(silhouette_avg)

    # 绘制不同k值的轮廓分数图 （Silhouette）
    plt.figure(figsize=(7, 5))
    plt.plot(k_values, silhouette_scores, 'go-')  # 绘制轮廓分数曲线图
    if lang == 'zh':
        plt.title('最優 k 的 Silhouette 方法')
        plt.xlabel('簇的數量 (k)')
        plt.ylabel('Silhouette 得分')
    else:
        plt.title('Silhouette Method For Optimal k')
        plt.xlabel('Number of clusters (k)')
        plt.ylabel('Silhouette Score')
    plt.savefig(buffer, format='png') # Save the plot to the buffer as PNG
    plt.clf() # Clear the current figure
    plt.close() # Close the figure
    image_data2 = base64.b64encode(buffer.getvalue()).decode('utf-8') # Convert the buffer content to base64
    buffer.seek(0) # Reset the buffer position

    optimal_clusters = np.argmax(silhouette_scores) + minRange  # Add minRange to account for starting from minRange clusters
    #################################################################################################################################################################
    # k number of clusters to be extracted
    # k starts at 2 when the length is less than 20, then increases by 1 for each additional 20 units of length.
    # The min function is used to ensure that k does not exceed 10
    k = optimal_clusters # min(len(timeSeries) // 20 + 2, 10)
    cluster_index_list = []
    cluster_ori_list = [] # List used to store the original values ​​in the cluster index
    cluster_mean_list = []
    delta_abso_list = []
    delta_abso_percent_list = []
    delta_relative_percent_list = []
    cluster_ratio_list = []
    upper_count = 0
    lower_count = 0
    baseline_count = 0
    upper_percent = 0
    lower_percent = 0
    max_val = 0
    min_val = 0
    upper_list = []
    lower_list = []
    baseline_list = []
    majority_list = []
    minority_list = []
    current_price = subsequent_trends[0][0]
    total_trends_len = len(subsequent_trends)

    # Get the cluster indices in each cluster from Z
    clusters = hac.fcluster(Z, k, criterion='maxclust') # Perform 2nd clustering to extract k clusters
    unique_clusters = np.unique(clusters)
    unique_clusters_with_len = [(x, len(np.where(clusters == x)[0])) for x in unique_clusters] # Get the lengths of the clusters
    sorted_clusters = sorted(unique_clusters_with_len, key=lambda x: x[1], reverse=True) # Sort the clusters by their lengths in descending order
    longest_cluster, second_longest_cluster = sorted_clusters[0][1], sorted_clusters[1][1] # The longest and second longest clusters are now at index 0 and 1
    # If secondary_longest_cluster is too short to be a reliable cluster
    if second_longest_cluster < longest_cluster / 10:
        clusters = hac.fcluster(Z, len(timeSeries) // 2, criterion='maxclust') # Perform 2nd clustering again to extract more clusters
        distances = [Z[cluster - 1, 2] if cluster > 1 else 0 for cluster in clusters] # Get the distances of the unique clusters
        # Perform 3rd clustering
        pairwise_distances = pdist(np.array(distances).reshape(-1, 1)) # Compute pairwise distances between unique clusters by Euclidean distance
        # Method: single, complete, average, ward (requires the distance metric to be Euclidean)
        # Ref https://medium.com/@iqra.bismi/different-linkage-methods-used-in-hierarchical-clustering-627bde3787e8
        Z_new = hac.linkage(pairwise_distances, method='ward')

        # Plot dendogram
        plt.figure(figsize=(7, 5))
        if lang == 'zh':
            plt.title('分層聚類樹狀圖')
            plt.xlabel('樣本索引')
            plt.ylabel('距離')
        else:
            plt.title('Hierarchical Clustering Dendrogram')
            plt.xlabel('sample index')
            plt.ylabel('distance')
        dendrogram = hac.dendrogram(
            Z_new,
            leaf_rotation=90.,  # rotates the x axis labels
            leaf_font_size=8.,  # font size for the x axis labels
        )
        plt.savefig(buffer, format='png') # Save the plot to the buffer as PNG
        plt.clf() # Clear the current figure
        plt.close() # Close the figure
        image_data1 = base64.b64encode(buffer.getvalue()).decode('utf-8') # Convert the buffer content to base64
        buffer.seek(0) # Reset the buffer position

        clusters = hac.fcluster(Z_new, k, criterion='maxclust') # Perform 4th clustering to extract k clusters
        unique_clusters = np.unique(clusters)
    
    # Append cluster indices to cluster_index_list
    for cluster in unique_clusters:
        indices = np.where(clusters == cluster)[0]
        cluster_index_list.append(indices)

    # Get the original values in each cluster indices from cluster_index_list
    for i in range(len(cluster_index_list)):
        original_values = [timeSeries.iloc[i].tolist() for i in cluster_index_list[i]]
        cluster_ori_list.append(original_values)
    
    # Get the mean values for each sublist in original_values without modifying the first item
    for original_values in cluster_ori_list:
        means = [current_price] + [sum(sublist) / len(sublist) for sublist in zip(*original_values)][1:]
        cluster_mean_list.append(means)
    #################################################################################################################################################################
    colors = ['red', 'blue', 'green', 'purple', 'orange', 'pink', 'brown', 'gray', 'cyan', 'magenta']
    line_styles = ['-', '--', '-.', ':'] # solid line ('-'), dashed line ('--'), dash-dot line ('-.'), dotted line (':')

    #1 Plot subsequent trends
    plt.figure(figsize=(7, 5))
    for trend in subsequent_trends:
        plt.plot(trend, color='black', alpha=0.25)
    if lang == 'zh':
        plt.title('同一模擬起點的後續走勢')
        plt.xlabel('時間')
        plt.ylabel('值')
    else:
        plt.title('Subsequent trends at the same simulation starting point')
        plt.xlabel('Time')
        plt.ylabel('Value')
    plt.savefig(buffer, format='png') # Save the plot to the buffer as PNG
    plt.clf() # Clear the current figure
    plt.close() # Close the figure
    image_data3 = base64.b64encode(buffer.getvalue()).decode('utf-8') # Convert the buffer content to base64
    buffer.seek(0) # Reset the buffer position

    longest_original_values = max([len(original_values) for original_values in cluster_ori_list]) # Find the longest cluster across all original_values
    plt.figure(figsize=(7, 5))
    for i, original_values in enumerate(cluster_ori_list):
    #2 Plot subsequent trends clusters by the stored original_values arrays with different colors and line styles
        # If the length of the current original_values equals the longest, set alpha to 0.25 to improve readability
        if len(original_values) == longest_original_values:
            for values in original_values:
                plt.plot(values, color=colors[i % 10], linestyle=line_styles[i % 4], alpha=0.25)
        else:
            for values in original_values:
                plt.plot(values, color=colors[i % 10], linestyle=line_styles[i % 4], alpha=1)
    if lang == 'zh':
        plt.title('同一模擬起點的後續走勢簇')
        plt.xlabel('時間')
        plt.ylabel('值')
    else:
        plt.title('Subsequent trends clusters at the same simulation starting point')
        plt.xlabel('Time')
        plt.ylabel('Value')
    plt.savefig(buffer, format='png') # Save the plot to the buffer as PNG
    plt.clf() # Clear the current figure
    plt.close() # Close the figure
    image_data4 = base64.b64encode(buffer.getvalue()).decode('utf-8') # Convert the buffer content to base64
    buffer.seek(0) # Reset the buffer position

    plt.figure(figsize=(7, 5))
    for i, original_values in enumerate(cluster_ori_list):
    #3 Plot subsequent trends clusters and their means by the stored original_values arrays with different colors and line styles
        for values in original_values:
            # Set subsequent trends clusters alpha to 0.1 to improve readability
            plt.plot(values, color=colors[i % 10], linestyle=line_styles[i % 4], alpha=0.1)
        plt.plot(cluster_mean_list[i], color=colors[i % 10], linestyle=line_styles[i % 4], alpha=1)
    if lang == 'zh':
        plt.title('同一模擬起點的後續走勢簇及其平均')
        plt.xlabel('時間')
        plt.ylabel('值')
    else:
        plt.title('Subsequent trends clusters and their means at the same simulation starting point')
        plt.xlabel('Time')
        plt.ylabel('Value')
    plt.savefig(buffer, format='png') # Save the plot to the buffer as PNG
    plt.clf() # Clear the current figure
    plt.close() # Close the figure
    image_data5 = base64.b64encode(buffer.getvalue()).decode('utf-8') # Convert the buffer content to base64
    buffer.seek(0) # Reset the buffer position

    #4 Plot Demo
    main_df_data = []
    figure, axis = plt.subplots(figsize=(9, 5))
    for i, original_values in enumerate(cluster_ori_list):
        # for values in original_values:
        #     # Set subsequent trends clusters alpha to 0.1 to improve readability
        #     plt.plot(values, color=colors[i % 10], linestyle=line_styles[i % 4], alpha=0.1)
        for j, values in enumerate(original_values):
            for k, value in enumerate(values):
                main_df_data.append({'cluster': i, 'sublist': j, 'position': k, 'value': value})
        main_df = pd.DataFrame(main_df_data)
        delta_abso = round(cluster_mean_list[i][-1] - cluster_mean_list[i][0], 2)
        delta_abso_list.append(delta_abso)
        delta_abso_percent = round((cluster_mean_list[i][-1] - cluster_mean_list[i][0]) / cluster_mean_list[i][0] * 100, 2)
        delta_abso_percent_list.append(delta_abso_percent)
        delta_relative_percent = round(math.log(cluster_mean_list[i][-1] / cluster_mean_list[i][0]) * 100, 2)
        delta_relative_percent_list.append(delta_relative_percent)
        cluster_ratio = round((len(original_values)/total_trends_len) * 100, 2)
        cluster_ratio_list.append(cluster_ratio)
        plt.plot(cluster_mean_list[i], color=colors[i % 10], linestyle=line_styles[i % 4], 
                alpha=1, label=f'{delta_abso_list[i]} ({delta_abso_percent_list[i]}/{delta_relative_percent_list[i]}%) | {cluster_ratio_list[i]}%', 
                linewidth=3)
        # Count and append the values that are greater and smaller than starting point value
        for values in original_values:
            last_value = values[-1]
            if last_value > current_price:
                upper_count += 1
                upper_list.append(last_value)
            elif last_value < current_price:
                lower_count += 1
                lower_list.append(last_value)
            else:
                baseline_count += 1
                baseline_list.append(last_value)
    # Avoid multiple plotting
    dash_patterns = [(5, 1), (4, 2, 1, 2), (3, 1, 1, 1), (1, 1)]  # List of dash patterns for each hue
    hue_line_styles = {hue: dash for hue, dash in zip(main_df['cluster'].unique(), dash_patterns)}
    missing_hues = set(main_df['cluster'].unique()) - set(hue_line_styles.keys())
    for missing_hue in missing_hues:
        hue_line_styles[missing_hue] = (1, 1)  # Default dash pattern
    sns.lineplot(data=main_df, x='position', y='value', hue='cluster', palette=colors[:len(cluster_ori_list)], style='cluster', dashes=hue_line_styles, legend=False, alpha=0.1)
    ### Calculation of upper/lower percentage and set them to the 2nd y-axis
    upper_percent = round(upper_count / (upper_count + lower_count + baseline_count) * 100, 2)
    lower_percent = round(lower_count / (upper_count + lower_count + baseline_count) * 100, 2)
    
    ### 2nd y-axis
    axis_y_second = axis.twinx()
    left_y_min, left_y_max = axis.get_ylim()
    axis_y_second.set_ylim(left_y_min, left_y_max)
    axis_y_second.set_yticks([
        ((left_y_max - current_price) / 2) + current_price,
        ((left_y_min - current_price) / 2) + current_price])
    axis_y_second.set_yticklabels([
        f'{upper_count} ({upper_percent}%)'.format(upper_count = upper_count, upper_percent = upper_percent),
        f'{lower_count} ({lower_percent}%)'.format(lower_count = lower_count, lower_percent = lower_percent)])
    axis_y_second.tick_params(right=False)
    ### Set current price to the 3rd y-axis
    if lang == 'zh':
        axis.plot([current_price] * len(cluster_ori_list[0][0]),
                    color='black', linestyle='-', alpha=1, label='現價線', linewidth=5)
    else:
        axis.plot([current_price] * len(cluster_ori_list[0][0]),
                    color='black', linestyle='-', alpha=1, label='Current price', linewidth=5)
    axis_y_third = axis.twinx()
    axis_y_third.set_ylim(left_y_min, left_y_max)
    axis_y_third.set_yticks([current_price])
    axis_y_third.set_yticklabels([round(current_price, 2)])
    axis_y_third.tick_params(right=True)

    # Distribution preparations
    if len(upper_list) > len(lower_list):
        majority_list = upper_list + baseline_list
        minority_list = lower_list + baseline_list
    else:
        majority_list = lower_list + baseline_list
        minority_list = upper_list + baseline_list
    # Calculate the mean and standard deviation of the majority_list
    mean = np.mean(majority_list)
    std = np.std(majority_list)
    normal_dist = norm(loc=mean, scale=std) # Create a normal distribution object with the calculated mean and standard deviation
    percentiles = [normal_dist.cdf(i) for i in majority_list] # Calculate the percentiles for each value in the majority_list based on the normal distribution
    majority_and_percentile_list = list(zip(majority_list, percentiles)) # Pair each value in the majority_list with its corresponding percentile
    # Constants for percentile thresholds
    # For first values that are greater than -2 std (0.0228), -1 std (0.1587), 1 std (0.8413), 2 std (0.9772)
    percentiles_thresholds = [0.0228, 0.1587, 0.8413, 0.9772]
    majorities_found = [0] * len(percentiles_thresholds) # Initialize counters for the majorities
    # Iterate over each majority and percentile in the list
    for majority, percentile in majority_and_percentile_list:
        for i, percentiles_threshold in enumerate(percentiles_thresholds):
            if percentile < percentiles_threshold and i < len(percentiles_thresholds) / 2:
                if majorities_found[i] == 0:
                    majorities_found[i] = majority
                elif majority > majorities_found[i]:
                    majorities_found[i] = majority
            if percentile > percentiles_threshold and i >= len(percentiles_thresholds) / 2:
                if majorities_found[i] == 0:
                    majorities_found[i] = majority
                elif majority < majorities_found[i]:
                    majorities_found[i] = majority
    # If not found
    for i, percentiles_threshold in enumerate(percentiles_thresholds):
        if majorities_found[i] == 0:
            if i < len(percentiles_thresholds) / 2:
                majorities_found[i] = min(majority_list)
            if i >= len(percentiles_thresholds) / 2:
                majorities_found[i] = max(majority_list)

    # Find the median position between percentiles
    median_found = [0] * (len(majorities_found) - 1) # Initialize counters for the median
    percentage_found = [0] * (len(majorities_found) - 1) # Initialize counters for the percentages
    # Iterate over each majority in the list
    for i, majority in enumerate(majorities_found):
        if i < len(majorities_found) - 1:
            median_found[i] = (majority + majorities_found[i + 1]) / 2
            percentage_found[i] = f'{round((percentiles_thresholds[i + 1] - percentiles_thresholds[i]) * 100, 2)}%'

    # Set the title, xlabel, and ylabel
    if lang == 'zh':
        plt.title('同一模擬起點的後續走勢簇及其平均、多數/少數比率和回報')
        plt.xlabel('時間')
        plt.ylabel('')
        # Set the legend
        legend = axis.legend(loc='lower left')
        legend.set_title('回報 (簡單/對數%) | 佔比')
    else:
        plt.title('Subsequent trends clusters and their means at the same simulation starting point \nwith majority/minority ratios, and returns')
        plt.xlabel('Time')
        plt.ylabel('')
        # Set the legend
        legend = axis.legend(loc='lower left')
        legend.set_title('Return (Simple/Log%) | Proportion')
    plt.tight_layout()
    plt.savefig(buffer, format='png', bbox_inches='tight') # Save the plot to the buffer as PNG
    plt.clf() # Clear the current figure
    plt.close() # Close the figure
    image_data6 = base64.b64encode(buffer.getvalue()).decode('utf-8') # Convert the buffer content to base64
    buffer.seek(0) # Reset the buffer position
    #################################################################################################################################################################
    # 5 Plot Demo with Distribution Side Plot
    figure, axis = plt.subplots(figsize=(9, 5))
    for i, original_values in enumerate(cluster_ori_list):
        plt.plot(cluster_mean_list[i], color=colors[i % 10], linestyle=line_styles[i % 4], 
                alpha=1, label=f'{delta_abso_list[i]} ({delta_abso_percent_list[i]}/{delta_relative_percent_list[i]}%) | {cluster_ratio_list[i]}%', 
                linewidth=3)
    sns.lineplot(data=main_df, x='position', y='value', hue='cluster', palette=colors[:len(cluster_ori_list)], style='cluster', dashes=hue_line_styles, legend=False, alpha=0.1)
    # Find the minimum and maximum values in the 'value' column for the last 'position'
    last_position = main_df['position'].max()
    last_position_values = main_df.loc[main_df['position'] == last_position, 'value']
    min_val = last_position_values.min()
    max_val = last_position_values.max()
    axis.set_ylim(min_val, max_val)
    ### 2nd y-axis
    axis_y_second = axis.twinx()
    left_y_min, left_y_max = axis.get_ylim()
    axis_y_second.set_ylim(left_y_min, left_y_max)
    axis_y_second.set_yticks([
        ((left_y_max - current_price) / 2) + current_price,
        ((left_y_min - current_price) / 2) + current_price])
    axis_y_second.set_yticklabels([
        f'{upper_count} ({upper_percent}%)'.format(upper_count = upper_count, upper_percent = upper_percent),
        f'{lower_count} ({lower_percent}%)'.format(lower_count = lower_count, lower_percent = lower_percent)])
    axis_y_second.tick_params(right=False)
    ### Set current price to the 3rd y-axis
    if lang == 'zh':
        axis.plot([current_price] * len(cluster_ori_list[0][0]),
                    color='black', linestyle='-', alpha=1, label='現價線', linewidth=5)
    else:
        axis.plot([current_price] * len(cluster_ori_list[0][0]),
                    color='black', linestyle='-', alpha=1, label='Current price', linewidth=5)
    axis_y_third = axis.twinx()
    axis_y_third.set_ylim(left_y_min, left_y_max)
    axis_y_third.set_yticks([current_price])
    axis_y_third.set_yticklabels([round(current_price, 2)])
    axis_y_third.tick_params(right=True)
    ### Set percentiles position to the 4th y-axis
    axis_y_fourth = axis.twinx()
    axis_y_fourth.set_ylim(left_y_min, left_y_max)
    axis_y_fourth.set_yticks(majorities_found)
    axis_y_fourth.set_yticklabels([''] * len(majorities_found))
    axis_y_fourth.spines['right'].set_position(('outward', 75))
    axis_y_fourth.tick_params(labelright=False)
    ### Set percentages to the 5th y-axis
    axis_y_fifth = axis.twinx()
    axis_y_fifth.set_ylim(left_y_min, left_y_max)
    axis_y_fifth.set_yticks(median_found)
    axis_y_fifth.set_yticklabels(percentage_found)
    axis_y_fifth.spines['right'].set_position(('outward', 75))
    axis_y_fifth.tick_params(labelright=True, right=False)
    
    # Set the title
    if lang == 'zh':
        plt.title('同一模擬起點的後續走勢簇及其平均、多數/少數比率、多數分佈和回報')
        plt.xlabel('時間')
        plt.ylabel('')
        # Set the legend
        legend = axis.legend(loc='lower left')
        legend.set_title('回報 (簡單/對數%) | 佔比')
    else:
        plt.title('Subsequent trends clusters and their means at the same simulation starting point \nwith majority/minority ratios, majority distribution, and returns')
        plt.xlabel('Time')
        plt.ylabel('')
        # Set the legend
        legend = axis.legend(loc='lower left')
        legend.set_title('Return (Simple/Log%) | Proportion')
    plt.tight_layout()
    plt.savefig(buffer, format='png', bbox_inches='tight') # Save the plot to the buffer as PNG
    plt.clf() # Clear the current figure
    plt.close() # Close the figure
    image_data8 = base64.b64encode(buffer.getvalue()).decode('utf-8') # Convert the buffer content to base64
    buffer.seek(0) # Reset the buffer position
    #################################################################################################################################################################
    plt.figure(figsize=(7, 5))
    # Plot the histogram of the majority_list
    if lang == 'zh':
        plt.hist(majority_list, bins=20, density=True, alpha=0.6, label='多數列表')
    else:
        plt.hist(majority_list, bins=20, density=True, alpha=0.6, label='Majority List')
    # Generate x values for the normal distribution
    x = np.linspace(min(majority_list), max(majority_list), 100)
    pdf = normal_dist.pdf(x) # Calculate the PDF for the x values
    # Scale the PDF (Probability Density Function) to match the histogram
    pdf_scaled = pdf * len(majority_list) * np.diff(np.histogram(majority_list, bins=20)[1][0:2])
    if lang == 'zh':
        plt.plot(x, pdf_scaled, 'r-', label='分佈') # Plot the normal distribution as a line plot
        plt.xlabel('價格')
        plt.ylabel('機率密度 (a.u.)')
        plt.title('分佈圖')
    else:
        plt.plot(x, pdf_scaled, 'r-', label='Distribution') # Plot the normal distribution as a line plot
        plt.xlabel('Prices')
        plt.ylabel('Probability Density (a.u.)')
        plt.title('Distribution Chart')
    plt.legend()
    plt.savefig(buffer, format='png') # Save the plot to the buffer as PNG
    plt.clf() # Clear the current figure
    plt.close() # Close the figure
    image_data7 = base64.b64encode(buffer.getvalue()).decode('utf-8') # Convert the buffer content to base64
    buffer.seek(0) # Reset the buffer position
    #################################################################################################################################################################
    # PDF Displot
    df = pd.DataFrame({'pdf': pdf})
    df_sorted = df.sort_values(by='pdf') # Sort the DataFrame by the 'pdf' column in ascending order
    sns.displot(df_sorted['pdf'], kde=True)
    if lang == 'zh':
        plt.xlabel('PDF')
        plt.ylabel('數量')
    else:
        plt.xlabel('PDF')
        plt.ylabel('Count')
    plt.savefig(buffer, format='png') # Save the plot to the buffer as PNG
    plt.clf() # Clear the current figure
    plt.close() # Close the figure
    image_data9 = base64.b64encode(buffer.getvalue()).decode('utf-8') # Convert the buffer content to base64
    buffer.seek(0) # Reset the buffer position
    #################################################################################################################################################################
    # Side Plot
    g = sns.displot(data=main_df, y="value", kind="kde", height=4, aspect=.7)
    if lang == 'zh':
        g.set_axis_labels("機率密度 (a.u.)", "")
    else:
        g.set_axis_labels("Probability Density (a.u.)", "")
    plt.tight_layout()
    plt.ylim(round(min_value, 2), round(max_value, 2))  # Replace with your desired min and max values
    plt.savefig(buffer, format='png', transparent=True) # Save the plot to the buffer as PNG
    plt.clf() # Clear the current figure
    plt.close() # Close the figure
    image_data10 = base64.b64encode(buffer.getvalue()).decode('utf-8') # Convert the buffer content to base64
    buffer.seek(0) # Reset the buffer position
    #################################################################################################################################################################
    csv_png_files = {}

    # Iterate over the sublists and create separate CSV files
    all_clusters = []
    for sublist in cluster_ori_list:
        cluster_data = {}
        column_labels = ["Close " + str(j + 1) for j in range(len(sublist[0]))]
        for col_label in column_labels:
            cluster_data[col_label] = []
        for row in sublist:
            for col_label, cell_value in zip(column_labels, row):
                cluster_data[col_label].append(cell_value)
        all_clusters.append(cluster_data)
    csv_png_files['clusters.csv'] = all_clusters
    csv_png_files['num_of_clusters'] = len(cluster_ori_list)

    cluster_means_data = {}
    cluster_means_labels = ["Close " + str(j + 1) for j in range(len(cluster_mean_list[0]))]
    for col_label in cluster_means_labels:
        cluster_means_data[col_label] = []
    for row in cluster_mean_list:
        for col_label, cell_value in zip(cluster_means_labels, row):
            cluster_means_data[col_label].append(cell_value)
    csv_png_files['cluster_means.csv'] = cluster_means_data

    abso_returns_data = {}
    abso_returns_labels = ["Delta abso", "Delta abso percent"]
    for col_label in abso_returns_labels:
        abso_returns_data[col_label] = []
    for abso, abso_percent in zip(delta_abso_list, delta_abso_percent_list):
        abso_returns_data["Delta abso"].append(abso)
        abso_returns_data["Delta abso percent"].append(abso_percent)
    csv_png_files['returns_abso.csv'] = abso_returns_data

    relative_returns_data = {}
    relative_returns_labels = ["Delta abso", "Delta relative percent"]
    for col_label in relative_returns_labels:
        relative_returns_data[col_label] = []
    for abso, relative_percent in zip(delta_abso_list, delta_relative_percent_list):
        relative_returns_data["Delta abso"].append(abso)
        relative_returns_data["Delta relative percent"].append(relative_percent)
    csv_png_files['returns_relative.csv'] = relative_returns_data

    upper_and_lower_data = {}
    upper_and_lower_labels = ["Upper count", "Upper percent", "Lower count", "Lower percent"]
    for col_label in upper_and_lower_labels:
        upper_and_lower_data[col_label] = []
    upper_and_lower_data["Upper count"].append(upper_count)
    upper_and_lower_data["Upper percent"].append(upper_percent)
    upper_and_lower_data["Lower count"].append(lower_count)
    upper_and_lower_data["Lower percent"].append(lower_percent)
    csv_png_files['upper_and_lower.csv'] = upper_and_lower_data

    normal_dist_data = {}
    normal_dist_labels = ["Lowest 13.59%", "Lowest 68.26%", "Highest 68.26%", "Lowest 13.59%"]
    for col_label in normal_dist_labels:
        normal_dist_data[col_label] = []
    normal_dist_data["Lowest 13.59%"].append(majorities_found[0])
    normal_dist_data["Lowest 68.26%"].append(majorities_found[1])
    normal_dist_data["Highest 68.26%"].append(majorities_found[2])
    normal_dist_data["Lowest 13.59%"].append(majorities_found[3])
    csv_png_files['normal_dist.csv'] = normal_dist_data

    csv_png_files['img1'] = image_data6
    csv_png_files['img2'] = image_data5
    csv_png_files['img3'] = image_data4
    csv_png_files['img4'] = image_data3
    csv_png_files['img5'] = image_data7
    csv_png_files['img6'] = image_data2
    csv_png_files['img7'] = image_data1
    csv_png_files['img8'] = image_data8
    csv_png_files['img9'] = image_data9
    csv_png_files['img10'] = image_data10

    csv_png_files['max_silhouette_score'] = f'{max(silhouette_scores)}'

    # Save the csv_png_files as a JSON file
    json_data = {"csv_png_files": csv_png_files}
    # Convert the JSON data to a string
    json_string = json.dumps(json_data)
    # Return the JSON response
    return json_string