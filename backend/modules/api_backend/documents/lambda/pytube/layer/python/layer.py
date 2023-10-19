from pytube import YouTube

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

def download_ytd_object(video_url,itag):

    # Create a YouTube object
    yt = YouTube(video_url)

    # Get the highest resolution stream
    video_stream = yt.streams.get_by_itag(itag)

    # download video
    video_stream.download()

 




# video_url = "https://www.youtube.com/watch?v=fA2XtiZdDkE"
# download_ytd_object(video_url, 18)


#     # Specify the download location (change this to your desired location)
# download_path = "/path/to/your/download/folder/"

# # Download the video
# video_stream.download(output_path=download_path)