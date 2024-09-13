<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ultimate 8-Bit Multiverse Saga</title>
    <style>
        body { margin: 0; padding: 0; background: #000; overflow: hidden; }
        canvas { display: block; }
        #loading { position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); color: #fff; font-family: 'Press Start 2P', cursive; }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap" rel="stylesheet">
</head>
<body>
    <canvas id="gameCanvas"></canvas>
    <div id="loading">Loading Epic 8-Bit Universe...</div>
    <script>
    // Ultimate 8-Bit Multiverse Saga Engine

    const canvas = document.getElementById('gameCanvas');
    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    // Massive Game State
    const gameState = {
        player: {
            x: canvas.width / 2,
            y: canvas.height / 2,
            health: 100,
            mana: 50,
            inventory: [],
            skills: {},
            quests: [],
            dimension: 'overworld'
        },
        world: {
            dimensions: ['overworld', 'underworld', 'skyworld', 'cyberdimension'],
            currentDimension: 'overworld',
            time: 0,
            weather: 'clear',
            npcs: [],
            enemies: [],
            items: [],
            structures: []
        },
        ui: {
            currentMenu: null,
            dialogueQueue: [],
            notifications: []
        },
        settings: {
            soundVolume: 0.7,
            musicVolume: 0.5,
            difficulty: 'normal'
        },
        statistics: {
            enemiesDefeated: 0,
            questsCompleted: 0,
            itemsCrafted: 0,
            dimensionsExplored: new Set()
        }
    };

    // 8-Bit Model System
    class EightBitModel {
        constructor(pixelData, palette) {
            this.pixelData = pixelData;
            this.palette = palette;
            this.width = pixelData[0].length;
            this.height = pixelData.length;
        }

        draw(ctx, x, y, scale = 1) {
            for (let row = 0; row < this.height; row++) {
                for (let col = 0; col < this.width; col++) {
                    const colorIndex = this.pixelData[row][col];
                    if (colorIndex !== 0) { // 0 is transparent
                        ctx.fillStyle = this.palette[colorIndex];
                        ctx.fillRect(x + col * scale, y + row * scale, scale, scale);
                    }
                }
            }
        }
    }

    // Animation System
    class EightBitAnimation {
        constructor(frames, frameRate = 10) {
            this.frames = frames;
            this.frameRate = frameRate;
            this.currentFrame = 0;
            this.frameTimer = 0;
        }

        update(deltaTime) {
            this.frameTimer += deltaTime;
            if (this.frameTimer >= 1000 / this.frameRate) {
                this.currentFrame = (this.currentFrame + 1) % this.frames.length;
                this.frameTimer = 0;
            }
        }

        draw(ctx, x, y, scale = 1) {
            this.frames[this.currentFrame].draw(ctx, x, y, scale);
        }
    }

    // Massive 8-Bit Model and Animation Library
    const PALETTES = {
        standard: ['transparent', '#000000', '#FFFFFF', '#FF0000', '#00FF00', '#0000FF', '#FFFF00', '#FF00FF', '#00FFFF'],
        nature: ['transparent', '#0C3823', '#1E8875', '#62C370', '#B4D6D3', '#E7ECEF'],
        cyber: ['transparent', '#0D0221', '#190535', '#3B185F', '#A12568', '#FEC260']
    };

    const MODELS = {
        player: new EightBitModel([
            [0,2,2,2,0],
            [0,3,3,3,0],
            [0,3,3,3,0],
            [0,4,3,4,0],
            [0,4,4,4,0],
            [0,4,0,4,0],
            [0,5,0,5,0]
        ], PALETTES.standard),
        
        tree: new EightBitModel([
            [0,0,5,0,0],
            [0,5,5,5,0],
            [5,5,5,5,5],
            [0,0,6,0,0],
            [0,0,6,0,0]
        ], PALETTES.nature),
        
        cyborgEnemy: new EightBitModel([
            [0,1,1,1,0],
            [1,7,1,7,1],
            [1,1,1,1,1],
            [0,1,8,1,0],
            [1,0,1,0,1]
        ], PALETTES.cyber)
    };

    const ANIMATIONS = {
        playerWalk: new EightBitAnimation([
            MODELS.player,
            new EightBitModel([
                [0,2,2,2,0],
                [0,3,3,3,0],
                [0,3,3,3,0],
                [0,4,3,4,0],
                [0,4,4,4,0],
                [4,0,4,0,4],
                [5,0,4,0,5]
            ], PALETTES.standard)
        ], 5),
        
        treeRustle: new EightBitAnimation([
            MODELS.tree,
            new EightBitModel([
                [0,5,0,0,0],
                [5,5,5,0,0],
                [5,5,5,5,5],
                [0,0,6,0,0],
                [0,0,6,0,0]
            ], PALETTES.nature)
        ], 2),
        
        cyborgAttack: new EightBitAnimation([
            MODELS.cyborgEnemy,
            new EightBitModel([
                [0,1,1,1,0],
                [1,7,1,7,1],
                [1,1,8,1,1],
                [0,1,8,1,0],
                [1,1,0,1,1]
            ], PALETTES.cyber)
        ], 8)
    };

    // Procedural Dimension Generation
    function generateDimension(name, size) {
        const dimension = {
            name: name,
            map: [],
            entities: [],
            items: [],
            structures: []
        };

        // Generate terrain
        for (let y = 0; y < size; y++) {
            dimension.map[y] = [];
            for (let x = 0; x < size; x++) {
                dimension.map[y][x] = Math.floor(Math.random() * 3);
            }
        }

        // Add entities
        for (let i = 0; i < size / 10; i++) {
            dimension.entities.push({
                type: Math.random() < 0.7 ? 'enemy' : 'npc',
                x: Math.floor(Math.random() * size),
                y: Math.floor(Math.random() * size)
            });
        }

        // Add items
        for (let i = 0; i < size / 20; i++) {
            dimension.items.push({
                type: ['health', 'mana', 'weapon'][Math.floor(Math.random() * 3)],
                x: Math.floor(Math.random() * size),
                y: Math.floor(Math.random() * size)
            });
        }

        // Add structures
        for (let i = 0; i < size / 50; i++) {
            dimension.structures.push({
                type: ['house', 'dungeon', 'shop'][Math.floor(Math.random() * 3)],
                x: Math.floor(Math.random() * size),
                y: Math.floor(Math.random() * size)
            });
        }

        return dimension;
    }

    // Generate all dimensions
    gameState.world.dimensions.forEach(dim => {
        gameState.world[dim] = generateDimension(dim, 1000);
    });

    // Advanced Particle System
    class ParticleSystem {
        constructor() {
            this.particles = [];
        }

        emit(x, y, color, count, options = {}) {
            const defaults = {
                speed: 2,
                size: 2,
                life: 60,
                spread: Math.PI * 2
            };
            const settings = { ...defaults, ...options };

            for (let i = 0; i < count; i++) {
                const angle = Math.random() * settings.spread;
                const speed = Math.random() * settings.speed;
                this.particles.push({
                    x, y,
                    vx: Math.cos(angle) * speed,
                    vy: Math.sin(angle) * speed,
                    color,
                    size: settings.size,
                    life: settings.life
                });
            }
        }

        update() {
            this.particles = this.particles.filter(p => {
                p.x += p.vx;
                p.y += p.vy;
                p.life--;
                return p.life > 0;
            });
        }

        draw(ctx) {
            this.particles.forEach(p => {
                ctx.fillStyle = p.color;
                ctx.globalAlpha = p.life / 60;
                ctx.fillRect(p.x, p.y, p.size, p.size);
            });
            ctx.globalAlpha = 1;
        }
    }

    const particleSystem = new ParticleSystem();

    // Quantum Entanglement Puzzle System
    class QuantumPuzzle {
        constructor() {
            this.qubits = Array(8).fill().map(() => Math.random() < 0.5 ? 0 : 1);
            this.entangledPairs = [[0,1], [2,3], [4,5], [6,7]];
            this.goal = Array(8).fill().map(() => Math.random() < 0.5 ? 0 : 1);
        }

        flip(index) {
            this.qubits[index] = 1 - this.qubits[index];
            const entangledPair = this.entangledPairs.find(pair => pair.includes(index));
            if (entangledPair) {
                const otherIndex = entangledPair[0] === index ? entangledPair[1] : entangledPair[0];
                this.qubits[otherIndex] = 1 - this.qubits[otherIndex];
            }
        }

        isSolved() {
            return this.qubits.every((qubit, index) => qubit === this.goal[index]);
        }

        draw(ctx, x, y) {
            ctx.font = '12px "Press Start 2P"';
            ctx.fillStyle = '#00FF00';
            ctx.fillText('Quantum Puzzle', x, y);
            this.qubits.forEach((qubit, index) => {
                ctx.fillStyle = qubit === 0 ? '#0000FF' : '#FF0000';
                ctx.fillRect(x + index * 20, y + 20, 15, 15);
            });
            ctx.fillStyle = '#FFFF00';
            ctx.fillText('Goal:', x, y + 50);
            this.goal.forEach((qubit, index) => {
                ctx.fillStyle = qubit === 0 ? '#0000FF' : '#FF0000';
                ctx.fillRect(x + index * 20, y + 60, 15, 15);
            });
        }
    }

    const quantumPuzzle = new QuantumPuzzle();

    // Interdimensional Crafting System
    const craftingRecipes = [
        { ingredients: ['wood', 'stone'], result: 'axe' },
        { ingredients: ['iron', 'leather'], result: 'armor' },
        { ingredients: ['crystal', 'mana_essence'], result: 'wand' },
        { ingredients: ['quantum_particle', 'void_essence'], result: 'dimensional_key' }
    ];

    function craft(ingredients) {
        const recipe = craftingRecipes.find(r => 
            r.ingredients.length === ingredients.length && 
            r.ingredients.every(ing => ingredients.includes(ing))
        );
        if (recipe) {
            gameState.statistics.itemsCrafted++;
            return recipe.result;
        }
        return null;
    }

    // Time Manipulation Mechanic
    let timeScale = 1;
    function manipulateTime(scale) {
        timeScale = scale;
        // Adjust game speed, particle effects, animations, etc.
    }

    // Adaptive Music System
    const musicTracks = {
        peaceful: { url: 'peaceful.mp3', volume: 0.5 },
        battle: { url: 'battle.mp3', volume: 0.7 },
        boss: { url: 'boss.mp3', volume: 1 }
    };

    let currentTrack = null;

    function playMusic(trackName) {
        if (currentTrack) {
            currentTrack.pause();
        }
        currentTrack = new Audio(musicTracks[trackName].url);
        currentTrack.volume = musicTracks[trackName].volume * gameState.settings.musicVolume;
        currentTrack.loop = true;
        currentTrack.play();
    }

    // Dynamic Weather System
    const weatherEffects = {
        clear: () => {},
        rain: () => {
            for (let i = 0; i < 10; i++) {
                particleSystem.emit(
                    Math.random() * canvas.width, 
                    0, 
                    '#6af', 
                    1, 
                    { speed: 5, life: 100, size: 2 }
                );
            }
        },
        snow: () => {
            for (let i = 0; i < 5; i++) {
                particleSystem.emit(
                    Math.random() * canvas.width, 
                    0, 
                    '#fff', 
                    1, 
                    { speed: 1, life: 200, size: 3 }
                );
            }
        },
        sandstorm: () => {
            for (let i = 0; i < 20; i++) {
                particleSystem.emit(
                    0, 
                    Math.random() * canvas.height, 
                    '#d2b48c', 
                    1, 
                    { speed: 7, life: 50, size: 1 }
                );
            }
        }
    };

    function updateWeather() {
        const weathers = Object.keys(weatherEffects);
        gameState.world.weather = weathers[Math.floor(Math.random() * weathers.length)];
    }

    // Expanded 8-Bit Model Library with Pixel Art for Everything
    const EXTENDED_MODELS = {
        // Player states
        playerIdle: new EightBitModel([
            [0,0,1,1,1,1,0,0],
            [0,1,2,2,2,2,1,0],
            [0,1,2,3,3,2,1,0],
            [0,1,2,2,2,2,1,0],
            [0,0,1,4,4,1,0,0],
            [0,0,1,4,4,1,0,0],
            [0,0,1,4,4,1,0,0],
            [0,0,1,5,5,1,0,0]
        ], PALETTES.standard),

        playerAttack: new EightBitModel([
            [0,0,1,1,1,1,0,0],
            [0,1,2,2,2,2,1,0],
            [0,1,2,3,3,2,1,0],
            [0,1,2,2,2,2,1,6],
            [0,0,1,4,4,1,6,6],
            [0,0,1,4,4,6,6,0],
            [0,0,1,4,4,1,0,0],
            [0,0,1,5,5,1,0,0]
        ], PALETTES.standard),

        // Enemies
        slime: new EightBitModel([
            [0,0,4,4,4,4,0,0],
            [0,4,4,4,4,4,4,0],
            [4,4,4,5,5,4,4,4],
            [4,4,5,5,5,5,4,4],
            [4,4,4,4,4,4,4,4]
        ], PALETTES.standard),

        bat: new EightBitModel([
            [1,0,0,0,0,0,0,1],
            [1,1,0,0,0,0,1,1],
            [1,1,1,1,1,1,1,1],
            [0,1,2,1,1,2,1,0],
            [0,0,1,1,1,1,0,0]
        ], PALETTES.standard),

        // NPCs
        villager: new EightBitModel([
            [0,0,1,1,1,1,0,0],
            [0,1,3,3,3,3,1,0],
            [0,1,3,2,2,3,1,0],
            [0,1,3,3,3,3,1,0],
            [0,0,1,4,4,1,0,0],
            [0,1,4,4,4,4,1,0],
            [0,1,4,0,0,4,1,0],
            [0,0,5,0,0,5,0,0]
        ], PALETTES.standard),

        // Items
        healthPotion: new EightBitModel([
            [0,0,1,1,1,0,0],
            [0,1,3,3,3,1,0],
            [1,3,3,3,3,3,1],
            [1,3,3,3,3,3,1],
            [0,1,3,3,3,1,0],
            [0,0,1,3,1,0,0],
            [0,0,0,1,0,0,0]
        ], {...PALETTES.standard, 3: '#FF0000'}),

        manaPotion: new EightBitModel([
            [0,0,1,1,1,0,0],
            [0,1,3,3,3,1,0],
            [1,3,3,3,3,3,1],
            [1,3,3,3,3,3,1],
            [0,1,3,3,3,1,0],
            [0,0,1,3,1,0,0],
            [0,0,0,1,0,0,0]
        ], {...PALETTES.standard, 3: '#0000FF'}),

        sword: new EightBitModel([
            [0,0,0,0,0,1,0],
            [0,0,0,0,1,2,1],
            [0,0,0,1,2,2,1],
            [0,0,1,2,2,1,0],
            [0,1,2,2,1,0,0],
            [1,3,2,1,0,0,0],
            [5,1,1,0,0,0,0],
            [1,0,0,0,0,0,0]
        ], PALETTES.standard),

        // UI Elements
        heart: new EightBitModel([
            [0,1,1,0,1,1,0],
            [1,2,2,1,2,2,1],
            [1,2,2,2,2,2,1],
            [0,1,2,2,2,1,0],
            [0,0,1,2,1,0,0],
            [0,0,0,1,0,0,0]
        ], {...PALETTES.standard, 1: '#FF0000', 2: '#FF6666'}),

        mana: new EightBitModel([
            [0,0,1,1,1,0,0],
            [0,1,2,2,2,1,0],
            [1,2,2,2,2,2,1],
            [1,2,2,2,2,2,1],
            [1,2,2,2,2,2,1],
            [0,1,2,2,2,1,0],
            [0,0,1,1,1,0,0]
        ], {...PALETTES.standard, 1: '#0000FF', 2: '#6666FF'}),

        // Environment
        tree: new EightBitModel([
            [0,0,0,4,4,4,0,0],
            [0,0,4,4,4,4,4,0],
            [0,4,4,4,4,4,4,4],
            [4,4,4,4,4,4,4,4],
            [0,0,0,5,5,0,0,0],
            [0,0,0,5,5,0,0,0],
            [0,0,0,5,5,0,0,0]
        ], PALETTES.nature),

        rock: new EightBitModel([
            [0,0,1,1,1,0],
            [0,1,2,2,2,1],
            [1,2,2,2,2,2],
            [1,2,2,2,2,2],
            [0,1,2,2,2,1],
            [0,0,1,1,1,0]
        ], {...PALETTES.standard, 1: '#808080', 2: '#A9A9A9'}),

        // Structures
        house: new EightBitModel([
            [0,0,0,1,1,0,0,0],
            [0,0,1,2,2,1,0,0],
            [0,1,2,2,2,2,1,0],
            [1,2,2,2,2,2,2,1],
            [1,2,3,2,2,3,2,1],
            [1,2,2,2,2,2,2,1],
            [1,2,2,3,3,2,2,1],
            [1,1,1,1,1,1,1,1]
        ], {...PALETTES.standard, 1: '#8B4513', 2: '#DEB887', 3: '#4169E1'})
    };

    // Extended Animation Set
    const EXTENDED_ANIMATIONS = {
        playerWalk: new EightBitAnimation([
            EXTENDED_MODELS.playerIdle,
            new EightBitModel([
                [0,0,1,1,1,1,0,0],
                [0,1,2,2,2,2,1,0],
                [0,1,2,3,3,2,1,0],
                [0,1,2,2,2,2,1,0],
                [0,0,1,4,4,1,0,0],
                [0,0,1,4,4,1,0,0],
                [0,1,4,0,4,0,1,0],
                [0,1,0,0,0,5,1,0]
            ], PALETTES.standard)
        ], 5),

        slimeBounce: new EightBitAnimation([
            EXTENDED_MODELS.slime,
            new EightBitModel([
                [0,0,0,0,0,0,0,0],
                [0,0,4,4,4,4,0,0],
                [0,4,4,4,4,4,4,0],
                [4,4,4,5,5,4,4,4],
                [4,4,5,5,5,5,4,4],
                [4,4,4,4,4,4,4,4]
            ], PALETTES.standard)
        ], 3),

        batFly: new EightBitAnimation([
            EXTENDED_MODELS.bat,
            new EightBitModel([
                [0,1,0,0,0,0,1,0],
                [1,0,1,0,0,1,0,1],
                [1,1,1,1,1,1,1,1],
                [0,1,2,1,1,2,1,0],
                [0,0,1,1,1,1,0,0]
            ], PALETTES.standard)
        ], 8)
    };

    // Quantum Realm Minigame
    class QuantumRealmMinigame {
        constructor() {
            this.particles = [];
            this.playerPosition = { x: canvas.width / 2, y: canvas.height / 2 };
            this.score = 0;
        }

        spawnParticle() {
            const edge = Math.floor(Math.random() * 4);
            let x, y;
            switch(edge) {
                case 0: x = 0; y = Math.random() * canvas.height; break;
                case 1: x = canvas.width; y = Math.random() * canvas.height; break;
                case 2: x = Math.random() * canvas.width; y = 0; break;
                case 3: x = Math.random() * canvas.width; y = canvas.height; break;
            }
            this.particles.push({ x, y, color: Math.random() < 0.5 ? 'blue' : 'red' });
        }

        update() {
            if (Math.random() < 0.05) this.spawnParticle();
            
            this.particles.forEach(particle => {
                const dx = this.playerPosition.x - particle.x;
                const dy = this.playerPosition.y - particle.y;
                const distance = Math.sqrt(dx*dx + dy*dy);
                particle.x += dx / distance;
                particle.y += dy / distance;

                if (distance < 10) {
                    if ((particle.color === 'blue' && input.keys['KeyB']) || 
                        (particle.color === 'red' && input.keys['KeyR'])) {
                        this.score++;
                    } else {
                        this.score = Math.max(0, this.score - 1);
                    }
                    this.particles = this.particles.filter(p => p !== particle);
                }
            });
        }

        draw(ctx) {
            ctx.fillStyle = 'black';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            this.particles.forEach(particle => {
                ctx.fillStyle = particle.color;
                ctx.beginPath();
                ctx.arc(particle.x, particle.y, 5, 0, Math.PI * 2);
                ctx.fill();
            });

            EXTENDED_MODELS.playerIdle.draw(ctx, this.playerPosition.x - 4, this.playerPosition.y - 4, 1);

            ctx.fillStyle = 'white';
            ctx.font = '20px "Press Start 2P"';
            ctx.fillText(`Score: ${this.score}`, 10, 30);
        }
    }

    const quantumRealmMinigame = new QuantumRealmMinigame();

    // Interdimensional Market
    class InterdimensionalMarket {
        constructor() {
            this.items = [
                { name: 'Quantum Shard', price: 100, model: new EightBitModel([
                    [0,0,1,1,0,0],
                    [0,1,2,2,1,0],
                    [1,2,2,2,2,1],
                    [1,2,2,2,2,1],
                    [0,1,2,2,1,0],
                    [0,0,1,1,0,0]
                ], {...PALETTES.standard, 1: '#4B0082', 2: '#9370DB'}) },
                { name: 'Void Essence', price: 250, model: new EightBitModel([
                    [0,1,1,1,1,0],
                    [1,0,0,0,0,1],
                    [1,0,2,2,0,1],
                    [1,0,2,2,0,1],
                    [1,0,0,0,0,1],
                    [0,1,1,1,1,0]
                ], {...PALETTES.standard, 1: '#191970', 2: '#483D8B'}) },
                { name: 'Temporal Gear', price: 500, model: new EightBitModel([
                    [0,1,1,1,1,0],
                    [1,0,2,2,0,1],
                    [1,2,0,0,2,1],
                    [1,2,0,0,2,1],
                    [1,0,2,2,0,1],
                    [0,1,1,1,1,0]
                ], {...PALETTES.standard, 1: '#B8860B', 2: '#FFD700'}) }
            ];
        }

        draw(ctx) {
            ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
            ctx.fillRect(50, 50, canvas.width - 100, canvas.height - 100);
            
            ctx.fillStyle = '#FFD700';
            ctx.font = '24px "Press Start 2P"';
            ctx.fillText('Interdimensional Market', 100, 100);

            this.items.forEach((item, index) => {
                const y = 150 + index * 80;
                item.model.draw(ctx, 100, y, 3);
                ctx.fillStyle = 'white';
                ctx.font = '16px "Press Start 2P"';
                ctx.fillText(item.name, 150, y + 20);
                ctx.fillText(`Price: ${item.price}`, 150, y + 40);
            });
        }

        buyItem(index) {
            const item = this.items[index];
            if (gameState.player.gold >= item.price) {
                gameState.player.gold -= item.price;
                gameState.player.inventory.push(item.name);
                return true;
            }
            return false;
        }
    }

    const interdimensionalMarket = new InterdimensionalMarket();

    // Dimensional Rift System
    class DimensionalRift {
        constructor() {
            this.active = false;
            this.position = { x: 0, y: 0 };
            this.size = 0;
            this.maxSize = 100;
            this.growthRate = 0.5;
        }

        activate(x, y) {
            this.active = true;
            this.position = { x, y };
            this.size = 0;
        }

        update() {
            if (this.active) {
                this.size += this.growthRate;
                if (this.size >= this.maxSize) {
                    this.active = false;
                    this.teleportPlayer();
                }
            }
        }

        draw(ctx) {
            if (this.active) {
                ctx.beginPath();
                ctx.arc(this.position.x, this.position.y, this.size, 0, Math.PI * 2);
                ctx.fillStyle = 'rgba(75, 0, 130, 0.6)';
                ctx.fill();
                ctx.strokeStyle = 'rgba(147, 112, 219, 0.8)';
                ctx.lineWidth = 3;
                ctx.stroke();
            }
        }

        teleportPlayer() {
            const dimensions = gameState.world.dimensions;
            const currentIndex = dimensions.indexOf(gameState.world.currentDimension);
            const nextIndex = (currentIndex + 1) % dimensions.length;
            gameState.world.currentDimension = dimensions[nextIndex];
            gameState.player.x = Math.random() * canvas.width;
            gameState.player.y = Math.random() * canvas.height;
            gameState.statistics.dimensionsExplored.add(gameState.world.currentDimension);
        }
    }

    const dimensionalRift = new DimensionalRift();

    // Advanced Combat System
    class CombatSystem {
        constructor() {
            this.inCombat = false;
            this.enemies = [];
            this.turns = [];
            this.currentTurn = 0;
        }

        initiateCombat(enemies) {
            this.inCombat = true;
            this.enemies = enemies;
            this.turns = [gameState.player, ...enemies].sort(() => Math.random() - 0.5);
            this.currentTurn = 0;
            playMusic('battle');
        }

        executeTurn(action) {
            const currentEntity = this.turns[this.currentTurn];
            if (currentEntity === gameState.player) {
                this.executePlayerAction(action);
            } else {
                this.executeEnemyAction(currentEntity);
            }
            this.currentTurn = (this.currentTurn + 1) % this.turns.length;
            this.checkCombatEnd();
        }

        executePlayerAction(action) {
            switch(action.type) {
                case 'attack':
                    const damage = Math.floor(Math.random() * 10) + 10;
                    action.target.health -= damage;
                    particleSystem.emit(action.target.x, action.target.y, '#FF0000', 20, { speed: 2, life: 40, size: 3 });
                    break;
                case 'magic':
                    const magicDamage = Math.floor(Math.random() * 20) + 15;
                    action.target.health -= magicDamage;
                    gameState.player.mana -= 10;
                    particleSystem.emit(action.target.x, action.target.y, '#00FFFF', 30, { speed: 3, life: 50, size: 2 });
                    break;
                case 'defend':
                    gameState.player.defending = true;
                    break;
            }
        }

        executeEnemyAction(enemy) {
            const damage = Math.floor(Math.random() * 5) + 5;
            if (gameState.player.defending) {
                gameState.player.health -= Math.floor(damage / 2);
                gameState.player.defending = false;
            } else {
                gameState.player.health -= damage;
            }
            particleSystem.emit(gameState.player.x, gameState.player.y, '#FF0000', 15, { speed: 1, life: 30, size: 2 });
        }

        checkCombatEnd() {
            if (gameState.player.health <= 0) {
                this.endCombat('defeat');
            } else if (this.enemies.every(e => e.health <= 0)) {
                this.endCombat('victory');
            }
        }

        endCombat(result) {
            this.inCombat = false;
            if (result === 'victory') {
                gameState.statistics.enemiesDefeated += this.enemies.length;
                const expGained = this.enemies.reduce((sum, e) => sum + e.expValue, 0);
                gameState.player.experience += expGained;
                // Check for level up
                if (gameState.player.experience >= 100 * gameState.player.level) {
                    gameState.player.level++;
                    gameState.player.experience -= 100 * (gameState.player.level - 1);
                    gameState.player.maxHealth += 20;
                    gameState.player.health = gameState.player.maxHealth;
                    gameState.player.maxMana += 10;
                    gameState.player.mana = gameState.player.maxMana;
                }
            }
            playMusic('peaceful');
        }

        draw(ctx) {
            if (this.inCombat) {
                ctx.fillStyle = 'rgba(0, 0, 0, 0.5)';
                ctx.fillRect(0, 0, canvas.width, canvas.height);

                // Draw player
                EXTENDED_MODELS.playerIdle.draw(ctx, 100, canvas.height - 150, 3);
                this.drawHealthBar(ctx, 100, canvas.height - 170, gameState.player.health, gameState.player.maxHealth);

                // Draw enemies
                this.enemies.forEach((enemy, index) => {
                    EXTENDED_MODELS[enemy.type].draw(ctx, canvas.width - 150 - (index * 100), canvas.height - 150, 3);
                    this.drawHealthBar(ctx, canvas.width - 150 - (index * 100), canvas.height - 170, enemy.health, enemy.maxHealth);
                });

                // Draw turn order
                ctx.fillStyle = 'white';
                ctx.font = '16px "Press Start 2P"';
                ctx.fillText('Turn Order:', 20, 30);
                this.turns.forEach((entity, index) => {
                    const name = entity === gameState.player ? 'Player' : entity.type;
                    ctx.fillStyle = index === this.currentTurn ? '#FFD700' : 'white';
                    ctx.fillText(name, 20, 60 + index * 30);
                });
            }
        }

        drawHealthBar(ctx, x, y, health, maxHealth) {
            const width = 60;
            const height = 10;
            ctx.fillStyle = '#333';
            ctx.fillRect(x, y, width, height);
            ctx.fillStyle = '#0F0';
            ctx.fillRect(x, y, (health / maxHealth) * width, height);
        }
    }

    const combatSystem = new CombatSystem();

    // Skill Tree System
    class SkillTree {
        constructor() {
            this.skills = {
                attack: { level: 0, maxLevel: 5, effect: (level) => ({ damage: level * 5 }) },
                defense: { level: 0, maxLevel: 5, effect: (level) => ({ armor: level * 3 }) },
                magic: { level: 0, maxLevel: 5, effect: (level) => ({ manaCost: -level }) },
                agility: { level: 0, maxLevel: 5, effect: (level) => ({ evasion: level * 2 }) }
            };
            this.skillPoints = 0;
        }

        upgradeSkill(skillName) {
            const skill = this.skills[skillName];
            if (skill && skill.level < skill.maxLevel && this.skillPoints > 0) {
                skill.level++;
                this.skillPoints--;
                return true;
            }
            return false;
        }

        getSkillEffect(skillName) {
            const skill = this.skills[skillName];
            return skill ? skill.effect(skill.level) : null;
        }

        draw(ctx) {
            ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
            ctx.fillRect(50, 50, canvas.width - 100, canvas.height - 100);

            ctx.fillStyle = '#FFD700';
            ctx.font = '24px "Press Start 2P"';
            ctx.fillText('Skill Tree', 100, 100);

            ctx.font = '16px "Press Start 2P"';
            ctx.fillText(`Skill Points: ${this.skillPoints}`, 100, 140);

            let y = 180;
            for (const [skillName, skill] of Object.entries(this.skills)) {
                ctx.fillStyle = 'white';
                ctx.fillText(`${skillName}: Level ${skill.level}/${skill.maxLevel}`, 100, y);
                for (let i = 0; i < skill.maxLevel; i++) {
                    ctx.fillStyle = i < skill.level ? '#00FF00' : '#333';
                    ctx.fillRect(400 + i * 30, y - 15, 20, 20);
                }
                y += 40;
            }
        }
    }

    const skillTree = new SkillTree();

    // Quest System
    class QuestSystem {
        constructor() {
            this.quests = [];
            this.completedQuests = [];
        }

        addQuest(quest) {
            this.quests.push(quest);
        }

        completeQuest(questId) {
            const questIndex = this.quests.findIndex(q => q.id === questId);
            if (questIndex !== -1) {
                const completedQuest = this.quests.splice(questIndex, 1)[0];
                this.completedQuests.push(completedQuest);
                gameState.player.experience += completedQuest.expReward;
                gameState.player.gold += completedQuest.goldReward;
                gameState.statistics.questsCompleted++;
            }
        }

        draw(ctx) {
            ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
            ctx.fillRect(50, 50, canvas.width - 100, canvas.height - 100);

            ctx.fillStyle = '#FFD700';
            ctx.font = '24px "Press Start 2P"';
            ctx.fillText('Quests', 100, 100);

            let y = 150;
            this.quests.forEach(quest => {
                ctx.fillStyle = 'white';
                ctx.font = '16px "Press Start 2P"';
                ctx.fillText(quest.title, 100, y);
                ctx.font = '12px "Press Start 2P"';
                ctx.fillText(quest.description, 100, y + 20);
                y += 60;
            });
        }
    }

    const questSystem = new QuestSystem();

    // Main game loop
    function gameLoop(timestamp) {
        const deltaTime = timestamp - lastTimestamp;
        lastTimestamp = timestamp;

        // Update game state
        updateGame(deltaTime);

        // Clear the canvas
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // Render game
        renderGame();

        // Request next frame
        requestAnimationFrame(gameLoop);
    }

    function updateGame(deltaTime) {
        if (gameState.world.currentDimension === 'quantumRealm') {
            quantumRealmMinigame.update();
        } else {
            // Update player position based on input
            if (input.keys['ArrowUp']) gameState.player.y -= 2;
            if (input.keys['ArrowDown']) gameState.player.y += 2;
            if (input.keys['ArrowLeft']) gameState.player.x -= 2;
            if (input.keys['ArrowRight']) gameState.player.x += 2;

            // Update animations
            EXTENDED_ANIMATIONS.playerWalk.update(deltaTime);
            EXTENDED_ANIMATIONS.slimeBounce.update(deltaTime);
            EXTENDED_ANIMATIONS.batFly.update(deltaTime);

            // Update weather
            weatherEffects[gameState.world.weather]();

            // Update dimensional rift
            dimensionalRift.update();

            // Update combat
            if (combatSystem.inCombat) {
                // Handle combat turns
            }

            // Update quests
            questSystem.quests.forEach(quest => {
                if (quest.checkCompletion()) {
                    questSystem.completeQuest(quest.id);
                }
            });

            // Update time and day/night cycle
            gameState.world.time += deltaTime / 1000;
            if (gameState.world.time >= 24) {
                gameState.world.time -= 24;
                gameState.world.day++;
            }
        }

        // Update particles
        particleSystem.update();
    }

    function renderGame() {
        if (gameState.world.currentDimension === 'quantumRealm') {
            quantumRealmMinigame.draw(ctx);
        } else {
            // Draw world
            const currentDimension = gameState.world[gameState.world.currentDimension];
            currentDimension.map.forEach((row, y) => {
                row.forEach((tile, x) => {
                    // Draw tile based on type
                });
            });

            // Draw structures
            currentDimension.structures.forEach(structure => {
                EXTENDED_MODELS[structure.type].draw(ctx, structure.x, structure.y, 2);
            });

            // Draw items
            currentDimension.items.forEach(item => {
                EXTENDED_MODELS[item.type].draw(ctx, item.x, item.y, 2);
            });

            // Draw NPCs
            currentDimension.npcs.forEach(npc => {
                EXTENDED_MODELS.villager.draw(ctx, npc.x, npc.y, 2);
            });

            // Draw enemies
            currentDimension.enemies.forEach(enemy => {
                if (enemy.type === 'slime') {
                    EXTENDED_ANIMATIONS.slimeBounce.draw(ctx, enemy.x, enemy.y, 2);
                } else if (enemy.type === 'bat') {
                    EXTENDED_ANIMATIONS.batFly.draw(ctx, enemy.x, enemy.y, 2);
                }
            });

            // Draw player
            EXTENDED_ANIMATIONS.playerWalk.draw(ctx, gameState.player.x, gameState.player.y, 2);

            // Draw dimensional rift
            dimensionalRift.draw(ctx);

            // Draw weather effects
            drawWeatherEffects();

            // Draw UI
            drawUI();

            // Draw combat if in combat
            if (combatSystem.inCombat) {
                combatSystem.draw(ctx);
            }
        }

        // Always draw particles on top
        particleSystem.draw(ctx);
    }

    function drawWeatherEffects() {
        ctx.fillStyle = 'rgba(0, 0, 0, ' + (0.2 + Math.sin(gameState.world.time * Math.PI / 12) * 0.2) + ')';
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        if (gameState.world.weather === 'rain') {
            for (let i = 0; i < 100; i++) {
                ctx.fillStyle = 'rgba(120, 120, 255, 0.5)';
                ctx.fillRect(
                    Math.random() * canvas.width,
                    Math.random() * canvas.height,
                    1,
                    5
                );
            }
        } else if (gameState.world.weather === 'snow') {
            for (let i = 0; i < 50; i++) {
                ctx.fillStyle = 'rgba(255, 255, 255, 0.8)';
                ctx.beginPath();
                ctx.arc(
                    Math.random() * canvas.width,
                    Math.random() * canvas.height,
                    2,
                    0,
                    Math.PI * 2
                );
                ctx.fill();
            }
        }
    }

    function drawUI() {
        // Draw health bar
        ctx.fillStyle = '#FF0000';
        ctx.fillRect(10, 10, gameState.player.health * 2, 20);
        ctx.strokeStyle = '#FFFFFF';
        ctx.strokeRect(10, 10, gameState.player.maxHealth * 2, 20);

        // Draw mana bar
        ctx.fillStyle = '#0000FF';
        ctx.fillRect(10, 40, gameState.player.mana * 2, 20);
        ctx.strokeStyle = '#FFFFFF';
        ctx.strokeRect(10, 40, gameState.player.maxMana * 2, 20);

        // Draw experience bar
        ctx.fillStyle = '#00FF00';
        ctx.fillRect(10, 70, (gameState.player.experience / (gameState.player.level * 100)) * 200, 10);
        ctx.strokeStyle = '#FFFFFF';
        ctx.strokeRect(10, 70, 200, 10);

        // Draw level
        ctx.fillStyle = '#FFFFFF';
        ctx.font = '16px "Press Start 2P"';
        ctx.fillText(`Level: ${gameState.player.level}`, 220, 80);

        // Draw gold
        EXTENDED_MODELS.coin.draw(ctx, canvas.width - 100, 10, 2);
        ctx.fillStyle = '#FFD700';
        ctx.fillText(`${gameState.player.gold}`, canvas.width - 70, 25);

        // Draw current dimension
        ctx.fillStyle = '#FFFFFF';
        ctx.fillText(`Dimension: ${gameState.world.currentDimension}`, 10, canvas.height - 20);

        // Draw time
        const hours = Math.floor(gameState.world.time);
        const minutes = Math.floor((gameState.world.time % 1) * 60);
        ctx.fillText(`Time: ${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`, canvas.width - 200, canvas.height - 20);
    }

    // Input handling
    const input = {
        keys: {},
        mouse: { x: 0, y: 0, pressed: false }
    };

    window.addEventListener('keydown', (e) => {
        input.keys[e.code] = true;
    });

    window.addEventListener('keyup', (e) => {
        input.keys[e.code] = false;
    });

    canvas.addEventListener('mousemove', (e) => {
        const rect = canvas.getBoundingClientRect();
        input.mouse.x = e.clientX - rect.left;
        input.mouse.y = e.clientY - rect.top;
    });

    canvas.addEventListener('mousedown', () => {
        input.mouse.pressed = true;
    });

    canvas.addEventListener('mouseup', () => {
        input.mouse.pressed = false;
    });

    // Inventory System
    class InventorySystem {
        constructor() {
            this.items = [];
            this.capacity = 20;
        }

        addItem(item) {
            if (this.items.length < this.capacity) {
                this.items.push(item);
                return true;
            }
            return false;
        }

        removeItem(index) {
            if (index >= 0 && index < this.items.length) {
                return this.items.splice(index, 1)[0];
            }
            return null;
        }

        draw(ctx) {
            ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
            ctx.fillRect(50, 50, canvas.width - 100, canvas.height - 100);

            ctx.fillStyle = '#FFD700';
            ctx.font = '24px "Press Start 2P"';
            ctx.fillText('Inventory', 100, 100);

            for (let i = 0; i < this.capacity; i++) {
                const x = 100 + (i % 5) * 80;
                const y = 150 + Math.floor(i / 5) * 80;
                ctx.strokeStyle = '#FFFFFF';
                ctx.strokeRect(x, y, 60, 60);

                if (i < this.items.length) {
                    EXTENDED_MODELS[this.items[i].type].draw(ctx, x + 10, y + 10, 2);
                    ctx.fillStyle = '#FFFFFF';
                    ctx.font = '12px "Press Start 2P"';
                    ctx.fillText(this.items[i].name, x, y + 75);
                }
            }
        }
    }

    const inventorySystem = new InventorySystem();

    // Crafting System
    class CraftingSystem {
        constructor() {
            this.recipes = [
                { name: 'Health Potion', ingredients: ['herb', 'water'], result: 'healthPotion' },
                { name: 'Mana Potion', ingredients: ['crystal', 'water'], result: 'manaPotion' },
                { name: 'Sword', ingredients: ['iron', 'wood'], result: 'sword' }
            ];
        }

        craft(recipe) {
            const canCraft = recipe.ingredients.every(ingredient => 
                inventorySystem.items.some(item => item.type === ingredient)
            );

            if (canCraft) {
                recipe.ingredients.forEach(ingredient => {
                    const index = inventorySystem.items.findIndex(item => item.type === ingredient);
                    inventorySystem.removeItem(index);
                });
                inventorySystem.addItem({ type: recipe.result, name: recipe.name });
                return true;
            }
            return false;
        }

        draw(ctx) {
            ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
            ctx.fillRect(50, 50, canvas.width - 100, canvas.height - 100);

            ctx.fillStyle = '#FFD700';
            ctx.font = '24px "Press Start 2P"';
            ctx.fillText('Crafting', 100, 100);

            this.recipes.forEach((recipe, index) => {
                const y = 150 + index * 100;
                ctx.fillStyle = '#FFFFFF';
                ctx.font = '16px "Press Start 2P"';
                ctx.fillText(recipe.name, 100, y);

                recipe.ingredients.forEach((ingredient, i) => {
                    EXTENDED_MODELS[ingredient].draw(ctx, 100 + i * 70, y + 20, 2);
                });

                ctx.fillText('=>', 300, y + 35);

                EXTENDED_MODELS[recipe.result].draw(ctx, 350, y + 20, 2);
            });
        }
    }

    const craftingSystem = new CraftingSystem();

    // Achievement System
    class AchievementSystem {
        constructor() {
            this.achievements = [
                { id: 'firstKill', name: 'First Blood', description: 'Defeat your first enemy', unlocked: false },
                { id: 'dimensionHopper', name: 'Dimension Hopper', description: 'Visit all dimensions', unlocked: false },
                { id: 'masterCrafter', name: 'Master Crafter', description: 'Craft all available items', unlocked: false }
            ];
        }

        checkAchievements() {
            if (!this.achievements.find(a => a.id === 'firstKill').unlocked && gameState.statistics.enemiesDefeated > 0) {
                this.unlockAchievement('firstKill');
            }
            if (!this.achievements.find(a => a.id === 'dimensionHopper').unlocked && gameState.statistics.dimensionsExplored.size === gameState.world.dimensions.length) {
                this.unlockAchievement('dimensionHopper');
            }
            // Add more achievement checks here
        }

        unlockAchievement(id) {
            const achievement = this.achievements.find(a => a.id === id);
            if (achievement && !achievement.unlocked) {
                achievement.unlocked = true;
                // Show notification
                gameState.ui.notifications.push(`Achievement Unlocked: ${achievement.name}`);
            }
        }

        draw(ctx) {
            ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
            ctx.fillRect(50, 50, canvas.width - 100, canvas.height - 100);

            ctx.fillStyle = '#FFD700';
            ctx.font = '24px "Press Start 2P"';
            ctx.fillText('Achievements', 100, 100);

            this.achievements.forEach((achievement, index) => {
                const y = 150 + index * 60;
                ctx.fillStyle = achievement.unlocked ? '#00FF00' : '#FF0000';
                ctx.font = '16px "Press Start 2P"';
                ctx.fillText(achievement.name, 100, y);
                ctx.fillStyle = '#FFFFFF';
                ctx.font = '12px "Press Start 2P"';
                ctx.fillText(achievement.description, 100, y + 20);
            });
        }
    }

    const achievementSystem = new AchievementSystem();

    // Main menu
    function drawMainMenu() {
        ctx.fillStyle = 'black';
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        ctx.fillStyle = '#FFD700';
        ctx.font = '48px "Press Start 2P"';
        ctx.fillText('8-Bit Multiverse Saga', canvas.width / 2 - 300, 100);

        const menuItems = ['New Game', 'Load Game', 'Options', 'Credits'];
        menuItems.forEach((item, index) => {
            ctx.fillStyle = 'white';
            ctx.font = '24px "Press Start 2P"';
            ctx.fillText(item, canvas.width / 2 - 100, 250 + index * 50);
        });
    }

    // Game initialization
    function initGame() {
        // Initialize game systems
        gameState.world.currentDimension = gameState.world.dimensions[0];
        updateWeather();
        
        // Start main game loop
        requestAnimationFrame(gameLoop);
    }

    // Start with main menu
    drawMainMenu();

    // Event listener for menu selection
    canvas.addEventListener('click', (e) => {
        const rect = canvas.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;

        if (x > canvas.width / 2 - 100 && x < canvas.width / 2 + 100) {
            if (y > 230 && y < 270) {
                initGame(); // New Game
            } else if (y > 280 && y < 320) {
                // Load Game (implement later)
            } else if (y > 330 && y < 370) {
                // Options (implement later)
            } else if (y > 380 && y < 420) {
                // Credits (implement later)
            }
        }
    });

    </script>
</body>
</html>
