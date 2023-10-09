import os
import hashlib
import glob
import argparse

''' Functions for running Python module from Job '''

def get_pymodule_cmd_arguments():
    parser = argparse.ArgumentParser(description='Sinara')
    parser.add_argument('--bentoservice_dir', 
                    nargs='*',
                    help='bentoservice_dir')
    parser.add_argument('--image_tag', 
                    nargs='*',
                    help='image_tag')

    args = parser.parse_args()
    
    return args

def get_bentoservice_dir(args):    
    if args.bentoservice_dir:
        return args.bentoservice_dir[0]
    
    return None

def get_image_tag(args):    
    if args.image_tag:
        return args.image_tag[0]
    
    return None

def get_safe_docker_image_name(name):
    # https://docs.docker.com/engine/reference/commandline/tag/#extended-description
    return name.lower().strip("._-")

def get_safe_docker_image_version(version):
    # https://docs.docker.com/engine/reference/commandline/tag/#extended-description
    return version.encode("ascii", errors="ignore").decode().lstrip(".-")[:128]

def compute_md5(file_name):
    hash_md5 = hashlib.md5()
    with open(file_name, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

def save_extra_info(bentoservice_dir, image_tag):
    file_paths = glob.glob(f'{bentoservice_dir}/*/artifacts/*')
    if len(file_paths) > 0:
        bento_service_class = os.path.basename(os.path.dirname(os.path.dirname(file_paths[0])))
        bentoservice_artifacts_dir = f'{bentoservice_dir}/{bento_service_class}/artifacts'
        os.mkdir(f'{bentoservice_artifacts_dir}/checksum')

        with open(f'{bentoservice_artifacts_dir}/checksum/artifacts_list.txt', 'w') as f:
            for file_path in file_paths:
                file_name = os.path.basename(file_path)
                #file_name_wo_ext = Path(file_path).stem
                f.write(f'{file_name}\n')
                with open(f'{bentoservice_artifacts_dir}/checksum/{file_name}.md5', 'w') as f2:
                    f2.write(compute_md5(file_path))

        with open(f'{bentoservice_artifacts_dir}/checksum/docker_image_info.txt', 'w') as f:
            f.write(image_tag)

if __name__ == '__main__':
    args = get_pymodule_cmd_arguments()
    bentoservice_dir = get_bentoservice_dir(args)
    image_tag = get_image_tag(args)

    save_extra_info(bentoservice_dir, image_tag)