import { useState } from 'react';



function UrlSubmit(props: any) {

    const [url, setUrl] = useState('');
    const [urlData, setUrlData] = useState('');

    const handleInputChange = (event:any) => {
        setUrl(event.target.value);
    };

    const handleSubmit = async () => {
        try{                        
            const response = await fetch('https://q7q9rbu94k.execute-api.eu-north-1.amazonaws.com/dev/url', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    "url": url
                }),
            });

            if (!response.ok) {
                throw new Error('Network response was not ok');
            }

            // const data = await response.json();
            setUrlData(await response.json());
            
            if (props.onSubmit) {
                props.onSubmit(urlData);
            }
        } catch(error) {
            console.error('API Error:', error);
        }       
    }       

    return(
        <form>
            <div className="input-group mb-3">
                <input 
                    type="text"
                    className="form-control"
                    placeholder="Enter your URL here..."
                    aria-label="Recipient's username"
                    aria-describedby="button-addon2"
                    value={url}
                    onChange={handleInputChange}
                />
                <button className="btn btn-primary"
                    type="button" 
                    id="button-addon2"
                    onClick={handleSubmit}
                >
                    Submit
                </button>

            </div>
        </form>
    );
}
export default UrlSubmit