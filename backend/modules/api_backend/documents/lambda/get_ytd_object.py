from pytube import YouTube

def get_ytd_object(event, context):
    # Create a YouTube object
    try:
        video_url = event['url']
        yt = YouTube(video_url)

        # Get the highest resolution stream
        video_stream = yt.streams.filter(file_extension='mp4', progressive=True)
        print(video_stream)
        video_info = {
            'title': yt.title,
            'thumbnail_url': yt.thumbnail_url,
            'resolutions': {
                'video/mp4': list(set(stream.resolution for stream in yt.streams.filter(file_extension='mp4') if stream.resolution is not None)),
            }
        }
        response = {
            'statusCode': 200,
            'success': True,
            'result': video_info
        }

        return response
    
    except Exception as e:
        return {
            'statusCode': 500,
            'success': False,
            'description': f"Error:: get_ytd_object:: {e}"
        }