import React, { useEffect, useState } from 'react';
import axios from 'axios';

const Home = () => {
  const [photos, setPhotos] = useState([]);

  useEffect(() => {
    axios.get('/api/photos/blk-123').then((res) => setPhotos(res.data));
  }, []);

  return (
    <div className="p-4">
      <h1 className="text-2xl font-bold mb-4">🐾 블록 123의 고양이들</h1>
      <div className="grid grid-cols-2 gap-4">
        {photos.map((photo, idx) => (
          <div key={idx} className="border rounded-xl p-2 shadow">
            <img src={photo.url} alt="cat" className="rounded-lg" />
            <p>{photo.description}</p>
            <p className="text-sm text-gray-500">{photo.date}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Home;
