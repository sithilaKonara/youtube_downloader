from pytube import YouTube
import boto3

# URL of the YouTube video you want to download

def get_ytd_object(video_url):
    # Create a YouTube object
    try:
        yt = YouTube(video_url)

        # Get the highest resolution stream
        video_stream = yt.streams.filter(file_extension='mp4', progressive=True)
        
        response = {
            'success': True,
            'result': video_stream
        }
        print(response)
        return response
    
    except Exception as e:
        response = {
            'success': False,
            'description': f"Error:: get_ytd_object:: {e}"
        } 
        return response

def download_ytd_object(video_url,itag, s3_bkt):

    # Create a YouTube object
    yt = YouTube(video_url)

    # Get the highest resolution stream
    video_stream = yt.streams.get_by_itag(itag)

    # download video
    video_stream.download(output_path="/tmp/")

    # Extract the original file name (without file extension)
    original_file_name = re.sub(r'[^\w\s.-]', '', yt.title)

    # Initialize an S3 client
    s3 = boto3.client('s3')

    # Upload the downloaded video to the specified S3 bucket
    s3.upload_file(f"/tmp/{video_stream.default_filename}", s3_bkt, "video", )



