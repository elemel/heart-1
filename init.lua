local AffineTransformation2 = require "heart.AffineTransformation2"
local Application = require "heart.Application"
local Camera = require "heart.Camera"
local CircleSprite = require "heart.CircleSprite"
local Game = require "heart.Game"
local GameScreen = "heart.GameScreen"
local LinkedSet = require "heart.LinkedSet"
local PolygonSprite = require "heart.PolygonSprite"
local Scene = require "heart.Scene"
local Sprite = require "heart.Sprite"
local SpriteLayer = require "heart.SpriteLayer"
local WorldView = require "heart.WorldView"

local heart = {}

heart.math = require "heart.math"
heart.math.newAffineTransformation2 = AffineTransformation2.new

heart.collection = {}
heart.collection.newLinkedSet = LinkedSet.new
heart.collection.newLinkedSetFromArray = LinkedSet.fromArray

heart.graphics = {}
heart.graphics.newCamera = Camera.new
heart.graphics.newCircleSprite = CircleSprite.new
heart.graphics.newPolygonSprite = PolygonSprite.new
heart.graphics.newScene = Scene.new
heart.graphics.newSprite = Sprite.new
heart.graphics.newSpriteLayer = SpriteLayer.new

heart.mouse = require "heart.mouse"

heart.game = {}
heart.game.newGame = Game.new
heart.game.newWorldView = WorldView.new

heart.application = {}
heart.application.newApplication = Application.new
heart.application.newGameScreen = GameScreen.new

return heart
