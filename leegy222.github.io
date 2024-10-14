<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오목 게임</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            font-family: Arial, sans-serif;
        }
        .controls {
            margin-bottom: 10px;
        }
        .board {
            display: grid;
            gap: 2px;
        }
        .cell {
            width: 40px;
            height: 40px;
            background-color: #f0d9b5;
            border: 1px solid black;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            font-size: 32px;
        }
        .black {
            color: black;
        }
        .white {
            color: white;
        }
        .highlight {
            animation: highlight 0.5s infinite alternate;
        }
        @keyframes highlight {
            0% { background-color: yellow; }
            100% { background-color: orange; }
        }
    </style>
</head>
<body>

<div class="controls">
    <label for="boardSize">보드 크기: </label>
    <select id="boardSize">
        <option value="15">15x15</option>
        <option value="10">10x10</option>
        <option value="20">20x20</option>
    </select>
    <button onclick="resetGame()">게임 시작</button>
</div>

<div class="board" id="board"></div>

<script>
    let boardSize = 15;  // 기본 보드 크기 15x15
    let board = [];
    let currentPlayer = 'black';
    const boardElement = document.getElementById('board');
    let movesCount = 0;

    // 보드 크기 선택
    document.getElementById('boardSize').addEventListener('change', function() {
        boardSize = parseInt(this.value);
        resetGame();
    });

    // 보드 그리기
    function drawBoard() {
        boardElement.innerHTML = '';
        boardElement.style.gridTemplateColumns = `repeat(${boardSize}, 40px)`;
        boardElement.style.gridTemplateRows = `repeat(${boardSize}, 40px)`;
        for (let y = 0; y < boardSize; y++) {
            for (let x = 0; x < boardSize; x++) {
                const cell = document.createElement('div');
                cell.classList.add('cell');
                cell.addEventListener('click', () => placeStone(x, y));
                if (board[y][x] === 'black') {
                    cell.classList.add('black');
                    cell.textContent = '●';
                } else if (board[y][x] === 'white') {
                    cell.classList.add('white');
                    cell.textContent = '○';
                }
                boardElement.appendChild(cell);
            }
        }
    }

    // 돌을 두는 함수
    function placeStone(x, y) {
        if (board[y][x] !== null) return;  // 이미 돌이 있는 곳에는 두지 않음
        board[y][x] = currentPlayer;
        movesCount++;
        drawBoard();
        if (checkWin(x, y)) {
            highlightWinningStones(x, y);
            setTimeout(() => alert(`${currentPlayer === 'black' ? '흑돌' : '백돌'} 승리!`), 100);
            resetGame();
        } else if (movesCount === boardSize * boardSize) {
            alert('무승부!');
            resetGame();
        } else {
            currentPlayer = currentPlayer === 'black' ? 'white' : 'black';
        }
    }

    // 승리 조건 체크
    function checkWin(x, y) {
        return (
            checkDirection(x, y, 1, 0) ||  // 가로
            checkDirection(x, y, 0, 1) ||  // 세로
            checkDirection(x, y, 1, 1) ||  // 대각선 \
            checkDirection(x, y, 1, -1)    // 대각선 /
        );
    }

    // 방향 체크 함수
    function checkDirection(x, y, dx, dy) {
        let count = 1;
        let color = board[y][x];
        let winningStones = [{x, y}];  // 승리한 돌의 위치 저장

        // 한 방향으로 카운트 증가
        for (let i = 1; i < 5; i++) {
            const nx = x + dx * i;
            const ny = y + dy * i;
            if (nx >= 0 && nx < boardSize && ny >= 0 && ny < boardSize && board[ny][nx] === color) {
                count++;
                winningStones.push({x: nx, y: ny});
            } else {
                break;
            }
        }

        // 반대 방향으로 카운트 증가
        for (let i = 1; i < 5; i++) {
            const nx = x - dx * i;
            const ny = y - dy * i;
            if (nx >= 0 && nx < boardSize && ny >= 0 && ny < boardSize && board[ny][nx] === color) {
                count++;
                winningStones.push({x: nx, y: ny});
            } else {
                break;
            }
        }

        if (count >= 5) {
            highlightStones(winningStones);  // 승리한 돌 강조
            return true;
        }

        return false;
    }

    // 승리한 돌 강조
    function highlightStones(stones) {
        for (const stone of stones) {
            const index = stone.y * boardSize + stone.x;
            const cell = boardElement.children[index];
            cell.classList.add('highlight');
        }
    }

    // 게임 초기화
    function resetGame() {
        board = Array(boardSize).fill().map(() => Array(boardSize).fill(null));
        movesCount = 0;
        currentPlayer = 'black';
        drawBoard();
    }

    resetGame();  // 처음 보드 그리기
</script>

</body>
</html>
