import React, { useState } from 'react';

const PlayerChoice = () => {
    const [selected, setSelected] = useState(false);

    const handleClick = (event: any) => {
        setSelected(event.target.value);
    }

    return (
        <div>
            <div className="flex flex-row items-center justify-center">
                <button className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full" onClick={handleClick} value="Heads">Heads</button>
                <button className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full" onClick={handleClick} value="Tails">Tails</button>
            </div>
        </div>
    )
};

export default PlayerChoice;