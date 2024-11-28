import os

# Path to the folder containing screenshots
folder_path = 'assets/screenshoot/'
image_extensions = ('.png', '.jpg', '.jpeg', '.gif', '.bmp', '.webp')

# Generate Markdown for each image
if os.path.exists(folder_path):
    files = sorted(os.listdir(folder_path))
    for file in files:
        if file.lower().endswith(image_extensions):
            image_path = os.path.join(folder_path, file).replace("\\", "/")
            print(f"![{file}]({image_path})\n")
else:
    print("No screenshots found in the folder.")
