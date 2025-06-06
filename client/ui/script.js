let hideTimeout = null;
let floatingDice = {};

window.addEventListener('message', function(event) {
    if (event.data.type === 'show') {
        showDice(event.data.dice, event.data.time);
    } else if (event.data.type === 'showFloating') {
        showFloatingDice(event.data.dice, event.data.x, event.data.y, event.data.id, event.data.scale);
    } else if (event.data.type === 'hideFloating') {
        hideFloatingDice();
    } else if (event.data.type === 'hideSpecificFloating') {
        hideSpecificFloatingDice(event.data.id);
    }
});

function showDice(diceArray, displayTime) {
    const container = document.getElementById('dice-container');
    container.innerHTML = '';
    for (let i = 0; i < diceArray.length; i++) {
        const diceDiv = document.createElement('div');
        diceDiv.className = 'dice';
        const img = document.createElement('img');
        img.src = `dice_${diceArray[i]}.png`;
        img.alt = `Dice ${diceArray[i]}`;
        diceDiv.appendChild(img);
        container.appendChild(diceDiv);
    }
    container.style.display = 'flex';
    clearTimeout(hideTimeout);
    hideTimeout = setTimeout(hideDice, displayTime || 8000);
}

function showFloatingDice(diceArray, x, y, id, scale = 1.0) {
    // Remove existing dice for this specific player if they exist
    hideSpecificFloatingDice(id);
    
    const container = document.createElement('div');
    container.id = `floating-dice-${id}`;
    container.className = 'floating-dice-container';
    container.style.position = 'absolute';
    container.style.left = (x * window.innerWidth - (100 * scale)) + 'px';
    container.style.top = (y * window.innerHeight - (100 * scale)) + 'px';
    container.style.display = 'flex';
    container.style.gap = (15 * scale) + 'px';
    container.style.zIndex = '9999';
    container.style.pointerEvents = 'none';
    container.style.transform = `scale(${scale})`;
    container.style.transformOrigin = 'center';
      
    for (let i = 0; i < diceArray.length; i++) {
        const diceDiv = document.createElement('div');
        diceDiv.className = 'floating-dice';
        diceDiv.style.width = '80px';
        diceDiv.style.height = '80px';
        diceDiv.style.background = 'rgba(0, 0, 0, 0.95)';
        diceDiv.style.borderRadius = '12px';
        diceDiv.style.display = 'flex';
        diceDiv.style.alignItems = 'center';
        diceDiv.style.justifyContent = 'center';
        diceDiv.style.animation = 'pop 0.3s';
        
        const img = document.createElement('img');
        img.src = `dice_${diceArray[i]}.png`;
        img.alt = `Dice ${diceArray[i]}`;
        img.style.width = '70px';
        img.style.height = '70px';
        img.style.userSelect = 'none';
        diceDiv.appendChild(img);
        container.appendChild(diceDiv);
    }
    
    document.body.appendChild(container);
    floatingDice[id] = container;
}

function hideSpecificFloatingDice(id) {
    const container = floatingDice[id];
    if (container && container.parentNode) {
        container.parentNode.removeChild(container);
        delete floatingDice[id];
    }
}

function hideFloatingDice() {
    Object.values(floatingDice).forEach(container => {
        if (container && container.parentNode) {
            container.parentNode.removeChild(container);
        }
    });
    floatingDice = {};
}

function hideDice() {
    document.getElementById('dice-container').style.display = 'none';
    fetch('https://Prodigy_DiceRoll/hide', { method: 'POST' });
}
