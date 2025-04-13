import React from 'react';

const CatCard = ({ photo }) => (
  <div className="border rounded-xl p-2 shadow">
    <img src={photo.url} alt="cat" className="rounded-lg" />
    <p>{photo.description}</p>
    <p className="text-sm text-gray-500">{photo.date}</p>
  </div>
);

export default CatCard;
