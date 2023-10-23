from pytube import YouTube
import boto3
import os
def download_ytd_object(event, context):
    try:
        video_url = event['url']
        itag = event['itag']

        # Create a YouTube object        
        yt = YouTube(video_url)

        # Create a unique file name for the video based on the video ID
        video_id = video_url.split('=')[-1]
        video_file_name = f'{video_id}.mp4'

        # Create a temporary directory to store the downloaded video
        download_dir = '/tmp'
        video_path = os.path.join(download_dir, video_file_name)

        # Get the highest resolution stream
        video_stream = yt.streams.get_by_itag(itag)

        # download video
        video_stream.download(output_path=download_dir, filename=video_file_name)

        s3_bucket_name = 'your-s3-bucket-name'
        s3_folder_name = 'video/'
        
        # Upload the video to S3
        s3_client = boto3.client('s3')
        s3_key = s3_folder_name + video_file_name
        s3_client.upload_file(video_path, s3_bucket_name, s3_key)
        
        os.remove(video_path)

        download_link ={"download_link" : f"https://s3.amazonaws.com/{s3_bucket_name}/{s3_key}"}

        response = {
            'statusCode': 200,
            'success': True,
            'result': download_link
        }
        return response

    except Exception as e:

        return {
            'statusCode': 500,
            'success': False,
            'description': f"Error:: get_ytd_object:: {e}"
        }