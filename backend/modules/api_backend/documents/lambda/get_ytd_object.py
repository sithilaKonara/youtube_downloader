from pytube import YouTube
import json

def get_ytd_object(event, context):

    try:
        body = json.loads(event['body'])
        video_url = body['url']
        # Create a YouTube object
        yt = YouTube(video_url)

        # Get the highest resolution stream
        video_stream = yt.streams.filter(file_extension='mp4', progressive=True)
        print(video_stream)
        video_info = {
            'title': yt.title,
            'thumbnail_url': yt.thumbnail_url,
            'resolutions': {
                'video/mp4': [{stream.resolution: stream.itag for stream in yt.streams.filter(file_extension='mp4') if stream.resolution is not None}]
            }
        }
        response = {
            'success': True,
            'result': video_info
        }

        return {
            'statusCode': 200,
            'body': json.dumps(response)
        }
    
    except Exception as e:
        response = {
            'success': False,
            'description': f"Error:: get_ytd_object:: {e}"
        }
        return {
            'statusCode': 500,
            'body': json.dumps(response)
        }
