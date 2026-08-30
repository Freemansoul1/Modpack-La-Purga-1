require "Items/SuburbsDistributions"

local gameNightDistro = {}

gameNightDistro.gameNightBoxes = {

    CheckersBox = { rolls = 1,
        items = {
            "GamePieceRed", 9999, "GamePieceRed", 9999, "GamePieceRed", 9999, "GamePieceRed", 9999,
            "GamePieceRed", 9999, "GamePieceRed", 9999, "GamePieceRed", 9999, "GamePieceRed", 9999,
            "GamePieceRed", 9999, "GamePieceRed", 9999, "GamePieceRed", 9999, "GamePieceRed", 9999,
            "GamePieceBlack", 9999, "GamePieceBlack", 9999, "GamePieceBlack", 9999, "GamePieceBlack", 9999,
            "GamePieceBlack", 9999, "GamePieceBlack", 9999, "GamePieceBlack", 9999, "GamePieceBlack", 9999,
            "GamePieceBlack", 9999, "GamePieceBlack", 9999, "GamePieceBlack", 9999, "GamePieceBlack", 9999,
            "CheckerBoard", 9999,
        },
        junk = { rolls = 1, items = {} }, fillRand = 0,
    },

    ChessBox = { rolls = 1,
        items = {
            "ChessWhiteKing", 9999, "ChessWhiteQueen", 9999,
            "ChessWhiteBishop", 9999, "ChessWhiteBishop", 9999,
            "ChessWhiteKnight", 9999, "ChessWhiteKnight", 9999,
            "ChessWhiteRook", 9999, "ChessWhiteRook", 9999,

            "ChessBlackKing", 9999, "ChessBlackQueen", 9999,
            "ChessBlackBishop", 9999, "ChessBlackBishop", 9999,
            "ChessBlackKnight", 9999, "ChessBlackKnight", 9999,
            "ChessBlackRook", 9999, "ChessBlackRook", 9999,

            "ChessWhite", 9999, "ChessWhite", 9999, "ChessWhite", 9999, "ChessWhite", 9999,
            "ChessWhite", 9999, "ChessWhite", 9999, "ChessWhite", 9999, "ChessWhite", 9999,

            "ChessBlack", 9999, "ChessBlack", 9999, "ChessBlack", 9999, "ChessBlack", 9999,
            "ChessBlack", 9999, "ChessBlack", 9999, "ChessBlack", 9999, "ChessBlack", 9999,

            "ChessBoard", 9999,
        },
        junk = { rolls = 1, items = {} }, fillRand = 0,
    },

    BackgammonBox = { rolls = 1,
        items = {
            "DiceWhite", 9999,
            "DiceWhite", 9999,
            "GamePieceBlackBackgammon", 9999, "GamePieceBlackBackgammon", 9999, "GamePieceBlackBackgammon", 9999,
            "GamePieceBlackBackgammon", 9999, "GamePieceBlackBackgammon", 9999, "GamePieceBlackBackgammon", 9999,
            "GamePieceBlackBackgammon", 9999, "GamePieceBlackBackgammon", 9999, "GamePieceBlackBackgammon", 9999,
            "GamePieceBlackBackgammon", 9999, "GamePieceBlackBackgammon", 9999, "GamePieceBlackBackgammon", 9999,
            "GamePieceBlackBackgammon", 9999, "GamePieceBlackBackgammon", 9999, "GamePieceBlackBackgammon", 9999,
            "GamePieceWhite", 9999, "GamePieceWhite", 9999, "GamePieceWhite", 9999,
            "GamePieceWhite", 9999, "GamePieceWhite", 9999, "GamePieceWhite", 9999,
            "GamePieceWhite", 9999, "GamePieceWhite", 9999, "GamePieceWhite", 9999,
            "GamePieceWhite", 9999, "GamePieceWhite", 9999, "GamePieceWhite", 9999,
            "GamePieceWhite", 9999, "GamePieceWhite", 9999, "GamePieceWhite", 9999,
            "BackgammonBoard", 9999,
        },
        junk = { rolls = 1, items = {} }, fillRand = 0,
    },

    PokerBox = { rolls = 1,
        items = {

            "PokerChips", 9999, "PokerChipsBlue", 9999,
            "PokerChipsYellow", 9999, "PokerChipsWhite", 9999,
            "PokerChipsBlack", 9999, "PokerChipsOrange", 9999,
            "PokerChipsPurple", 9999, "PokerChipsGreen", 9999,

            "CardDeck", 9999, "CardDeck", 9999,
            "Dice", 9999, "Dice", 9999,
        },
        junk = { rolls = 1, items = {} }, fillRand = 0,
    },

}

return gameNightDistro