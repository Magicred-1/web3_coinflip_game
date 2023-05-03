import { useState } from 'react';
import Betting from './Betting';
import PlayerChoice from './PlayerChoice';

const CoinFlip = () => {
    const [ani, setAni] = useState<'animate-coin' | ''>('');

    const flipCoin = () => {
    const betAmount = document.getElementById('bet-input')?.value != '';

    if (!betAmount) {
        alert('Please enter a bet amount first!');
        return;
    }

    setAni('animate-coin');
    setTimeout(() => {
    setAni('');
    }, 1000);
};

 // TODO: Add a random number generator to determine heads or tails based on the smart contract
const result = <p className="inline text-xl font-bold">{Math.random() < 0.5 ? 'Heads' : 'Tails'}</p>

return (
        <><div>
            <div className={'coin ' + ani}>{result}</div>
            <PlayerChoice />
            <Betting />
            <span><div className='mt-2' onClick={flipCoin}></div></span>
        </div></>
    );
};

export default CoinFlip;
