package collectionTask.player
{
	import collectionTask.CollectionTaskManager;
	import collectionTask.event.CollectionTaskEvent;
	import collectionTask.vo.PlayerVO;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.text.FilterFrameText;
	import com.pickgliss.ui.text.GradientText;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.events.SceneCharacterEvent;
	import ddt.manager.ChatManager;
	import ddt.utils.Helpers;
	import ddt.utils.PositionUtils;
	import ddt.view.FaceContainer;
	import ddt.view.chat.ChatData;
	import ddt.view.chat.ChatEvent;
	import ddt.view.chat.ChatInputView;
	import ddt.view.chat.chatBall.ChatBallPlayer;
	import ddt.view.common.VipLevelIcon;
	import ddt.view.sceneCharacter.SceneCharacterDirection;
	import ddt.view.scenePathSearcher.SceneScene;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import vip.VipController;
	
	public class CollectionTaskPlayer extends CollectionTaskPlayerBase
	{
		
		private var _playerVO:PlayerVO;
		
		private var _sceneScene:SceneScene;
		
		private var _spName:Sprite;
		
		private var _lblName:FilterFrameText;
		
		private var _vipName:GradientText;
		
		private var _isShowName:Boolean = true;
		
		private var _isChatBall:Boolean = true;
		
		private var _isShowPlayer:Boolean = true;
		
		private var _chatBallView:ChatBallPlayer;
		
		private var _face:FaceContainer;
		
		private var _vipIcon:VipLevelIcon;
		
		private var _walkOverHander:Function;
		
		private var _destinationPos:Point;
		
		private var _robertWalkVector:Vector.<Point>;
		
		private var _robertCollectTimer:Timer;
		
		private var _robertCollectCount:int;
		
		private var _currentWalkStartPoint:Point;
		
		public function CollectionTaskPlayer(playerVO:PlayerVO, callBack:Function = null)
		{
			this._playerVO = playerVO;
			this._currentWalkStartPoint = this._playerVO.playerPos;
			super(playerVO.playerInfo,callBack);
			this.initialize();
		}
		
		private function initialize() : void
		{
			moveSpeed = this._playerVO.playerMoveSpeed;
			if(this._isChatBall)
			{
				if(!this._chatBallView)
				{
					this._chatBallView = new ChatBallPlayer();
				}
				this._chatBallView.x = (playerWitdh - this._chatBallView.width) / 2 - playerWitdh / 2;
				this._chatBallView.y = -playerHeight + 40;
				addChild(this._chatBallView);
			}
			else
			{
				if(Boolean(this._chatBallView))
				{
					this._chatBallView.clear();
					if(Boolean(this._chatBallView.parent))
					{
						this._chatBallView.parent.removeChild(this._chatBallView);
					}
					this._chatBallView.dispose();
				}
				this._chatBallView = null;
			}
			if(!this._lblName)
			{
				this._lblName = ComponentFactory.Instance.creat("asset.collectionTask.characterPlayerNameAsset");
			}
			this._lblName.mouseEnabled = false;
			this._lblName.text = this.playerVO && this.playerVO.playerInfo && Boolean(this.playerVO.playerInfo.NickName) ? this.playerVO.playerInfo.NickName : "";
			if(!this._spName)
			{
				this._spName = new Sprite();
			}
			this._spName.addChild(this._lblName);
			if(this.playerVO.playerInfo.IsVIP)
			{
				this._vipName = VipController.instance.getVipNameTxt(-1,this.playerVO.playerInfo.typeVIP);
				this._vipName.textSize = 16;
				this._vipName.x = this._lblName.x;
				this._vipName.y = this._lblName.y;
				this._vipName.text = this._lblName.text;
				this._spName.addChild(this._vipName);
			}
			PositionUtils.adaptNameStyle(this._playerVO.playerInfo,this._lblName,this._vipName);
			if(this.playerVO.playerInfo.IsVIP && !this._vipIcon)
			{
				this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.collectionTask.VipIcon");
				if(this.playerVO.playerInfo.typeVIP >= 2)
				{
					this._vipIcon.y -= 5;
				}
				this._vipIcon.setInfo(this.playerVO.playerInfo,false);
			}
			if(Boolean(this._vipIcon))
			{
				this._spName.addChild(this._vipIcon);
				this._lblName.x = this._vipIcon.x + this._vipIcon.width;
				if(Boolean(this._vipName))
				{
					this._vipName.x = this._lblName.x;
				}
			}
			this._spName.x = (playerWitdh - this._spName.width) / 2 - playerWitdh / 2;
			this._spName.y = -playerHeight;
			this._spName.graphics.beginFill(0,0.5);
			var spWidth:int = Boolean(this._vipIcon) ? int(this._lblName.textWidth + this._vipIcon.width) : int(this._lblName.textWidth + 8);
			if(this.playerVO.playerInfo.IsVIP)
			{
				spWidth = Boolean(this._vipIcon) ? int(this._vipName.width + this._vipIcon.width + 8) : int(this._vipName.width + 8);
				this._spName.x = (playerWitdh - (this._vipIcon.width + this._vipName.width)) / 2 - playerWitdh / 2;
			}
			this._spName.graphics.drawRoundRect(-4,0,spWidth,22,5,5);
			this._spName.graphics.endFill();
			addChildAt(this._spName,0);
			this._spName.visible = this._isShowName;
			this._face = new FaceContainer(true);
			this._face.x = (playerWitdh - this._face.width) / 2 - playerWitdh / 2;
			this._face.y = -90;
			addChild(this._face);
			this.setEvent();
		}
		
		private function setEvent() : void
		{
			addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
			ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,this.__getChat);
			ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE,this.__getFace);
		}
		
		public function walk(p:Point, fun:Function = null) : void
		{
			if(!this._sceneScene)
			{
				return;
			}
			this._destinationPos = p;
			this.playerVO.walkPath = this._sceneScene.searchPath(playerPoint,p);
			this.playerVO.walkPath.shift();
			this.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(playerPoint,this.playerVO.walkPath[0]);
			this.playerVO.currentWalkStartPoint = this.currentWalkStartPoint;
			isWalkPathChange = true;
			this._walkOverHander = fun;
		}
		
		public function robertWalk(vector:Vector.<Point>) : void
		{
			this._robertWalkVector = vector;
			this.walk(this._robertWalkVector[int(Math.random() * 5)]);
		}
		
		private function characterDirectionChange(evt:SceneCharacterEvent) : void
		{
			this._playerVO.scenePlayerDirection = sceneCharacterDirection;
			if(Boolean(evt.data))
			{
				if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
				{
					if(sceneCharacterStateType == "natural")
					{
						sceneCharacterActionType = "naturalWalkBack";
					}
				}
				else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
				{
					if(sceneCharacterStateType == "natural")
					{
						sceneCharacterActionType = "naturalWalkFront";
					}
				}
			}
			else
			{
				if(this._playerVO.isRobert && this._walkOverHander == null)
				{
					this._robertCollectTimer = new Timer(5000);
					this._robertCollectTimer.addEventListener(TimerEvent.TIMER,this.__robertCollectCompleteHandler);
					this._robertCollectTimer.start();
				}
				else if(this._walkOverHander != null && CollectionTaskManager.Instance.isClickCollection && Math.abs(Point.distance(playerPoint,this._destinationPos)) == 0)
				{
					this._walkOverHander();
				}
				if(sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT)
				{
					if(sceneCharacterStateType == "natural")
					{
						sceneCharacterActionType = "naturalStandBack";
					}
				}
				else if(sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB)
				{
					if(sceneCharacterStateType == "natural")
					{
						sceneCharacterActionType = "naturalStandFront";
					}
				}
			}
		}
		
		protected function __robertCollectCompleteHandler(event:TimerEvent) : void
		{
			++this._robertCollectCount;
			this._robertCollectTimer.removeEventListener(TimerEvent.TIMER,this.__robertCollectCompleteHandler);
			this._robertCollectTimer.stop();
			this._robertCollectTimer = null;
			if(this._robertCollectCount == 5)
			{
				CollectionTaskManager.Instance.dispatchEvent(new CollectionTaskEvent(CollectionTaskEvent.REMOVE_ROBERT,this._playerVO.playerInfo.NickName));
			}
			else
			{
				this.walk(this._robertWalkVector[int(Math.random() * 5)]);
			}
		}
		
		public function set setSceneCharacterDirectionDefault(value:SceneCharacterDirection) : void
		{
			if(value == SceneCharacterDirection.LT || value == SceneCharacterDirection.RT)
			{
				if(sceneCharacterStateType == "natural")
				{
					sceneCharacterActionType = "naturalStandBack";
				}
			}
			else if(value == SceneCharacterDirection.LB || value == SceneCharacterDirection.RB)
			{
				if(sceneCharacterStateType == "natural")
				{
					sceneCharacterActionType = "naturalStandFront";
				}
			}
		}
		
		public function updatePlayer() : void
		{
			this.refreshCharacterState();
			this.characterMirror();
			this.playerWalkPath();
			update();
		}
		
		private function characterMirror() : void
		{
			var tmpSprite:Sprite = character;
			if(!isDefaultCharacter)
			{
				tmpSprite.scaleX = sceneCharacterDirection.isMirror ? -1 : 1;
				tmpSprite.x = sceneCharacterDirection.isMirror ? playerWitdh / 2 : -playerWitdh / 2;
			}
			else
			{
				tmpSprite.scaleX = 1;
				tmpSprite.x = -playerWitdh / 2;
			}
			tmpSprite.y = -playerHeight + 12;
		}
		
		private function playerWalkPath() : void
		{
			if(_walkPath != null && _walkPath.length > 0 && this._playerVO.walkPath.length > 0 && _walkPath != this._playerVO.walkPath)
			{
				this.fixPlayerPath();
			}
			if(this._playerVO && this._playerVO.walkPath && this._playerVO.walkPath.length <= 0 && !_tween.isPlaying)
			{
				return;
			}
			this.playerWalk(this._playerVO.walkPath);
		}
		
		override public function playerWalk(walkPath:Array) : void
		{
			var dis:Number = NaN;
			if(_walkPath != null && _tween.isPlaying && _walkPath == this._playerVO.walkPath)
			{
				return;
			}
			_walkPath = this._playerVO.walkPath;
			if(_walkPath.length > 0)
			{
				this._currentWalkStartPoint = _walkPath[0];
				sceneCharacterDirection = SceneCharacterDirection.getDirection(playerPoint,this._currentWalkStartPoint);
				dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,true));
				dis = Point.distance(this._currentWalkStartPoint,playerPoint);
				_tween.start(dis / _moveSpeed,"x",this._currentWalkStartPoint.x,"y",this._currentWalkStartPoint.y);
				_walkPath.shift();
			}
			else
			{
				dispatchEvent(new SceneCharacterEvent(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,false));
			}
		}
		
		private function fixPlayerPath() : void
		{
			var lastPath:Array = null;
			if(this._playerVO.currentWalkStartPoint == null)
			{
				return;
			}
			var startPointIndex:int = -1;
			for(var i:int = 0; i < _walkPath.length; i++)
			{
				if(_walkPath[i].x == this._playerVO.currentWalkStartPoint.x && _walkPath[i].y == this._playerVO.currentWalkStartPoint.y)
				{
					startPointIndex = i;
					break;
				}
			}
			if(startPointIndex > 0)
			{
				lastPath = _walkPath.slice(0,startPointIndex);
				this._playerVO.walkPath = lastPath.concat(this._playerVO.walkPath);
			}
		}
		
		public function get currentWalkStartPoint() : Point
		{
			return this._currentWalkStartPoint;
		}
		
		public function refreshCharacterState() : void
		{
			if((sceneCharacterDirection == SceneCharacterDirection.LT || sceneCharacterDirection == SceneCharacterDirection.RT) && _tween.isPlaying)
			{
				sceneCharacterActionType = "naturalWalkBack";
			}
			else if((sceneCharacterDirection == SceneCharacterDirection.LB || sceneCharacterDirection == SceneCharacterDirection.RB) && _tween.isPlaying)
			{
				sceneCharacterActionType = "naturalWalkFront";
			}
			moveSpeed = this._playerVO.playerMoveSpeed;
		}
		
		private function __getChat(evt:ChatEvent) : void
		{
			if(!this._isChatBall || !evt.data)
			{
				return;
			}
			var data:ChatData = ChatData(evt.data).clone();
			if(!data)
			{
				return;
			}
			data.msg = Helpers.deCodeString(data.msg);
			if(data.channel == ChatInputView.PRIVATE || data.channel == ChatInputView.CONSORTIA)
			{
				return;
			}
			if(data && this._playerVO.playerInfo && data.senderID == this._playerVO.playerInfo.ID)
			{
				this._chatBallView.setText(data.msg,this._playerVO.playerInfo.paopaoType);
				if(!this._chatBallView.parent)
				{
					addChildAt(this._chatBallView,this.getChildIndex(character) + 1);
				}
			}
		}
		
		private function __getFace(evt:ChatEvent) : void
		{
			var data:Object = evt.data;
			if(data["playerid"] == this._playerVO.playerInfo.ID)
			{
				this._face.setFace(data["faceid"]);
			}
		}
		
		public function get playerVO() : PlayerVO
		{
			return this._playerVO;
		}
		
		public function set playerVO(value:PlayerVO) : void
		{
			this._playerVO = value;
		}
		
		public function get isShowName() : Boolean
		{
			return this._isShowName;
		}
		
		public function set isShowName(value:Boolean) : void
		{
			this._isShowName = value;
			if(!this._spName)
			{
				return;
			}
			this._spName.visible = this._isShowName;
		}
		
		public function get isChatBall() : Boolean
		{
			return this._isChatBall;
		}
		
		public function set isChatBall(value:Boolean) : void
		{
			if(this._isChatBall == value || !this._chatBallView)
			{
				return;
			}
			this._isChatBall = value;
			if(this._isChatBall)
			{
				addChildAt(this._chatBallView,this.getChildIndex(character) + 1);
			}
			else if(Boolean(this._chatBallView) && Boolean(this._chatBallView.parent))
			{
				this._chatBallView.parent.removeChild(this._chatBallView);
			}
		}
		
		public function get isShowPlayer() : Boolean
		{
			return this._isShowPlayer;
		}
		
		public function set isShowPlayer(value:Boolean) : void
		{
			if(this._isShowPlayer == value)
			{
				return;
			}
			this._isShowPlayer = value;
			this.visible = this._isShowPlayer;
		}
		
		public function get sceneScene() : SceneScene
		{
			return this._sceneScene;
		}
		
		public function set sceneScene(value:SceneScene) : void
		{
			this._sceneScene = value;
		}
		
		public function get ID() : int
		{
			return this._playerVO.playerInfo.ID;
		}
		
		override public function dispose() : void
		{
			removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
			ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT,this.__getChat);
			ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE,this.__getFace);
			if(Boolean(this._robertCollectTimer))
			{
				this._robertCollectTimer.removeEventListener(TimerEvent.TIMER,this.__robertCollectCompleteHandler);
				this._robertCollectTimer.stop();
				this._robertCollectTimer = null;
			}
			this._sceneScene = null;
			if(Boolean(this._lblName) && Boolean(this._lblName.parent))
			{
				this._lblName.parent.removeChild(this._lblName);
			}
			this._lblName = null;
			ObjectUtils.disposeObject(this._vipName);
			this._vipName = null;
			if(Boolean(this._chatBallView))
			{
				this._chatBallView.clear();
				if(Boolean(this._chatBallView.parent))
				{
					this._chatBallView.parent.removeChild(this._chatBallView);
				}
				this._chatBallView.dispose();
			}
			this._chatBallView = null;
			if(Boolean(this._face))
			{
				this._face.clearFace();
				if(Boolean(this._face.parent))
				{
					this._face.parent.removeChild(this._face);
				}
				this._face.dispose();
			}
			this._face = null;
			if(Boolean(this._vipIcon))
			{
				this._vipIcon.dispose();
			}
			this._vipIcon = null;
			if(Boolean(this._playerVO))
			{
				this._playerVO.dispose();
			}
			this._playerVO = null;
			if(Boolean(this._spName) && Boolean(this._spName.parent))
			{
				this._spName.parent.removeChild(this._spName);
			}
			this._spName = null;
			super.dispose();
		}
	}
}

