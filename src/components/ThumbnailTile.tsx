import { SetStateAction, useState } from 'react';

function ThumbnailTile(props: any) {

    const [selectedOption, setSelectedOption] = useState("Format");
    const [conversionLink, setConversionLink] = useState(null);
    const [isConverting, setIsConverting] = useState(false);

    const { result: ytdata = {}, success: ytdataSuccess = false} = props.tdata;

    if ( ytdata === "" || !ytdataSuccess) {
        return(        
            <form>
                <div className="input-group mb-3">
                    <b>Opps !!! Some thing has happen. Please check the Url and try again.</b>
                </div>
            </form>
        );
    }
    console.log("DATA", ytdata);
    const handleOptionChange = (event: { 
        target: { value: SetStateAction<string>; }; 
    }) => {
        setSelectedOption(event.target.value); 
        setConversionLink(null);
    };

    const handleConvertClick = async () => {

        if ( selectedOption !=="Format" && !isConverting) {
            setIsConverting(true);

            // const [itag] = selectedOption;

            // Make a POST API call here
            try {
                const response = await fetch('https://ia29poyu60.execute-api.us-east-1.amazonaws.com/test/ytd/ytd_download', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        "url": ytdata.url,
                        "itag": selectedOption
                    }),
                });

                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }

                let apiResponse = await response.json();
                apiResponse = JSON.parse(apiResponse['body']);
                console.log(apiResponse);

                // Update the conversion link and button visibility based on the response
                if (apiResponse.success) {
                    setConversionLink(apiResponse.result.download_link);
                }
                
            } catch (error) {
                console.error('API Error:', error);
            } finally {
                setIsConverting(false);
            }
        }
    };

    const options = Object.entries(ytdata["video/mp4"]).map(([quality, value]) => (
        <option key={value as number} value={value as number}>
          {quality}
        </option>
    ));


    // const options = Object.entries(ytdata.resolutions || {}).flatMap(([format, qualities]) => (qualities as string[]).map((quality: string) => (
    //     <option key={`${format}-${quality}`} value={`${format}-${quality}`}>
    //         {`${format} - ${quality}`}
    //     </option>
    // )));
   
    return(        
        <form>
            <div className="input-group mb-3">
                <div className="container text-center">
                    <div className="row">
                        <div className="col">
                            <img src={ytdata.thumbnail_url} className="img-thumbnail" alt="..."></img>
                        </div>
                    </div>
                    <div className="row">
                        <div className="col">
                            <b>{ytdata.title}</b>
                        </div>
                    </div>
                    <div className="row">
                        <div className="col">
                            <select className="form-select" aria-label="Default select example" onChange={handleOptionChange} defaultValue="Format">
                                <option key="Format" disabled>Resolution</option>                                
                                {options}
                            </select>
                        
                        </div>                       
                        <div className="col">
                            {isConverting ? (
                                <button type="button" className="btn btn-primary" disabled>Converting...</button>
                            ) : (
                                <button type="button" className="btn btn-primary" onClick={handleConvertClick}>
                                    Convert
                                </button>
                            )}
                            {conversionLink && (
                                <a href={conversionLink} className="btn btn-success" download>
                                    Download
                                </a>
                            )}
                        </div>
                    </div>
                </div>
            </div>
        </form>
    );    
}
export default ThumbnailTile