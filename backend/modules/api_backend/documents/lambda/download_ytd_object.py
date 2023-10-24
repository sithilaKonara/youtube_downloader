from pytube import YouTube
import boto3
import os
import json

def download_ytd_object(event, context):

    cloud_front = os.environ['CLOUD_FRONT']
    download_dir = os.environ['DOWNLOAD_DIR']
    s3_bucket_name = os.environ['S3_BUCKET_NAME']
    s3_folder_name = os.environ['S3_FOLDER_NAME']


    try:
        video_url = event['queryStringParameters']['url']
        itag = event['queryStringParameters']['itag']

        # Create a YouTube object        
        yt = YouTube(video_url)

        # Create a unique file name for the video based on the video ID
        video_id = video_url.split('=')[-1]
        video_file_name = f'{video_id}.mp4'

        # Create a temporary directory to store the downloaded video
        video_path = os.path.join(download_dir, video_file_name)

        # Get the highest resolution stream
        video_stream = yt.streams.get_by_itag(itag)

        # download video
        video_stream.download(output_path=download_dir, filename=video_file_name)
        
        # Upload the video to S3
        s3_client = boto3.client('s3')
        s3_key = s3_folder_name + video_file_name
        s3_client.upload_file(video_path, s3_bucket_name, s3_key)
        
        os.remove(video_path)

        download_link ={"download_link" : f"https://{cloud_front}/{s3_bucket_name}/{s3_key}"}

        response = {
            'success': True,
            'result': download_link
        }
        return {
            'statusCode': 200,
            'body': json.dumps(response)
        }

    except Exception as e:

        response = {
            'success': False,
            'description': f"Error:: download_ytd_object:: {e}"
        }    
        return {
            'statusCode': 200,
            'body': json.dumps(response)
        }