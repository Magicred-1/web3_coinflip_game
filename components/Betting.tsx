import { useState } from 'react';

const Betting = () => {
    const [bet, setBet] = useState("");

    const handleChange = (event: any) => {
        setBet(event.target.value);
    };

    return (
        <div>
            <div className="relative">
                <input 
                    type="text" 
                    placeholder="Enter your bet"
                    value={bet} 
                    id="bet-input"
                    onChange={handleChange}
                    className="px-3 py-3 placeholder-slate-300 text-slate-600 relative bg-white bg-white rounded text-sm border border-slate-300 outline-none focus:outline-none focus:ring w-full"
                />
                <span className="absolute inset-y-0 right-0 flex items-center pr-3" style={{ pointerEvents: 'none' }}>
                <img src="https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/ethereum-eth-icon.png" alt="ETH icon" style={{ position: 'absolute', top: '50%', transform: 'translateY(-65%)', right: '0px', width: '20px', height: '20px' }} />
                </span>
            </div>
        </div>
    )
};

export default Betting;
