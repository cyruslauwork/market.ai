import json

FILE_NAME_WITH_EXTENSION = ['spy.json', 'qqq.json', 'uso.json', 'gld.json']

for file_name_with_extension in FILE_NAME_WITH_EXTENSION:
    with open(file_name_with_extension, 'r') as json_file:
        json_data = json.load(json_file)

    # Remove trailing .0 from volume values
    json_data = [{k: (int(v) if k == 'volume' else v) for k, v in item.items()} for item in json_data]

    # Print only the head 10 rows
    print(json.dumps(json_data[:1], indent=4))

    # Replace the original file in the OS
    with open(file_name_with_extension, 'w') as json_file:
        json.dump(json_data, json_file)

    # Check the replaced file in the OS
    with open(file_name_with_extension, 'r') as json_file:
        json_data = json.load(json_file)
        print(json.dumps(json_data[:1], indent=4))
        print(len(json_data))