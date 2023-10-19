from pytube import YouTube

def get_ytd_object(event, context):
    # Create a YouTube object
    try:
        video_url = event['url']
        yt = YouTube(video_url)

        # Get the highest resolution stream
        video_stream = yt.streams.filter(file_extension='mp4', progressive=True)

        return {
            'statusCode': 200,
            'success': True,
            'result': video_stream
        }
    
    except Exception as e:
        return {
            'statusCode': 500,
            'success': False,
            'description': f"Error:: get_ytd_object:: {e}"
        }