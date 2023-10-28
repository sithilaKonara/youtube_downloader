import UrlSubmit from "../components/UrlSubmit";
import ThumbnailTile from "../components/ThumbnailTile";
import { useState } from 'react';

function Home() {

    const [thumbnailTileData, seThumbnailTileData] = useState({});

    const handleUrlData = (data: any) => {
        // You can perform any necessary actions here before showing the ThumbnailTile
        seThumbnailTileData(data);
    };

    return(
        <div className="container text-center">
            <div className="row">
                <div className="col">
                    
                </div>
                <div className="col-xxl">
                    <UrlSubmit onSubmit={handleUrlData}
                    />
                    {Object.keys(thumbnailTileData).length !== 0 && <ThumbnailTile tdata={thumbnailTileData} />}
                </div>
                <div className="col">
                   
                </div>
            </div>
        </div>
    );
}
export default Home