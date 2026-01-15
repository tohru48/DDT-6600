package catchInsect.player
{
	import catchInsect.CatchInsectMananger;
	import catchInsect.event.CatchInsectEvent;
	import catchInsect.event.CatchInsectRoomEvent;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.text.FilterFrameText;
	import com.pickgliss.ui.text.GradientText;
	import com.pickgliss.utils.DisplayUtils;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.events.SceneCharacterEvent;
	import ddt.manager.ChatManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
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
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import road7th.comm.PackageIn;
	import vip.VipController;
	
	public class CatchInsectRoomPlayer extends CatchInsectRoomPlayerBase
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
		
		private var _fightIcon:MovieClip;
		
		private var _cakeIcon:Bitmap;
		
		private var _isReadyFight:Boolean;
		
		private var _currentWalkStartPoint:Point;
		
		public function CatchInsectRoomPlayer(playerVO:PlayerVO, callBack:Function = null)
		{
			this._playerVO = playerVO;
			this._currentWalkStartPoint = this._playerVO.playerPos;
			super(playerVO.playerInfo,callBack);
			this.initialize();
		}
		
		private function initialize() : void
		{
			var spWidth:int = 0;
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
			if(this._isShowName)
			{
				if(!this._lblName)
				{
					this._lblName = ComponentFactory.Instance.creat("catchInsect.room.characterPlayerNameAsset");
				}
				this._lblName.mouseEnabled = false;
				this._lblName.text = this.playerVO && this.playerVO.playerInfo && Boolean(this.playerVO.playerInfo.NickName) ? this.playerVO.playerInfo.NickName : "";
				this._lblName.textColor = 6029065;
				if(!this._spName)
				{
					this._spName = new Sprite();
				}
				if(this.playerVO.playerInfo.IsVIP)
				{
					this._vipName = VipController.instance.getVipNameTxt(-1,this.playerVO.playerInfo.typeVIP);
					this._vipName.textSize = 16;
					this._vipName.x = this._lblName.x;
					this._vipName.y = this._lblName.y;
					this._vipName.text = this._lblName.text;
					this._spName.addChild(this._vipName);
					DisplayUtils.removeDisplay(this._lblName);
				}
				else
				{
					this._spName.addChild(this._lblName);
					DisplayUtils.removeDisplay(this._vipName);
				}
				if(this.playerVO.playerInfo.IsVIP && !this._vipIcon)
				{
					this._vipIcon = new VipLevelIcon();
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
				spWidth = Boolean(this._vipIcon) ? int(this._lblName.textWidth + this._vipIcon.width) : int(this._lblName.textWidth + 8);
				if(this.playerVO.playerInfo.IsVIP)
				{
					spWidth = Boolean(this._vipIcon) ? int(this._vipName.width + this._vipIcon.width + 8) : int(this._vipName.width + 8);
					this._spName.x = (playerWitdh - (this._vipIcon.width + this._vipName.width)) / 2 - playerWitdh / 2;
				}
				this._spName.graphics.drawRoundRect(-4,0,spWidth,22,5,5);
				this._spName.graphics.endFill();
				addChildAt(this._spName,0);
				this._spName.visible = this._isShowName;
			}
			else
			{
				ObjectUtils.disposeObject(this._vipName);
				this._vipName = null;
				ObjectUtils.disposeObject(this._lblName);
				this._lblName = null;
			}
			this._face = new FaceContainer(true);
			this._face.x = (playerWitdh - this._face.width) / 2 - playerWitdh / 2;
			this._face.y = -90;
			addChild(this._face);
			this._fightIcon = ComponentFactory.Instance.creat("catchInsect.fighting");
			PositionUtils.setPos(this._fightIcon,"catchInsect.fightIconPos");
			addChild(this._fightIcon);
			this._fightIcon.visible = false;
			this._fightIcon.gotoAndStop(1);
			this._cakeIcon = ComponentFactory.Instance.creat("catchInsect.cakeIcon");
			addChild(this._cakeIcon);
			this._cakeIcon.visible = false;
			this.setStatus();
			this.setEvent();
		}
		
		public function setStatus() : void
		{
			switch(this._playerVO.playerStauts)
			{
				case 0:
					character.visible = true;
					this._fightIcon.visible = false;
					this._fightIcon.gotoAndStop(1);
					this._spName.y = -playerHeight;
					break;
				case 1:
					character.visible = true;
					this._fightIcon.visible = true;
					this._fightIcon.gotoAndPlay(1);
					this._spName.y = -playerHeight;
					break;
				case 2:
					character.visible = false;
					this._fightIcon.visible = false;
					this._fightIcon.gotoAndStop(1);
					this._spName.y = -playerHeight + 75;
			}
		}
		
		public function revive() : void
		{
			character.visible = true;
			this._fightIcon.visible = false;
			this._fightIcon.gotoAndStop(1);
			this._spName.y = -playerHeight;
		}
		
		private function __reviveComplete(e:Event) : void
		{
			var effot:MovieClip = e.currentTarget as MovieClip;
			effot.parent.removeChild(effot);
			effot = null;
		}
		
		private function setEvent() : void
		{
			addEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
			this._playerVO.addEventListener(CatchInsectRoomEvent.PLAYER_POS_CHANGE,this.__onplayerPosChangeImp);
			ChatManager.Instance.model.addEventListener(ChatEvent.ADD_CHAT,this.__getChat);
			ChatManager.Instance.addEventListener(ChatEvent.SHOW_FACE,this.__getFace);
			if(this.ID == PlayerManager.Instance.Self.ID)
			{
				CatchInsectMananger.instance.addEventListener(CatchInsectEvent.CAKE_STATUS,this.__updateCakeStatus);
				SocketManager.Instance.out.requestCakeStatus();
			}
		}
		
		protected function __updateCakeStatus(event:CatchInsectEvent) : void
		{
			var pkg:PackageIn = event.pkg;
			var bool:Boolean = pkg.readBoolean();
			this._cakeIcon.visible = bool;
		}
		
		private function __onplayerPosChangeImp(event:CatchInsectRoomEvent) : void
		{
			playerPoint = this._playerVO.playerPos;
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
				if(this.isReadyFight)
				{
					dispatchEvent(new CatchInsectRoomEvent(CatchInsectRoomEvent.READYFIGHT));
				}
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
			character.scaleX = sceneCharacterDirection.isMirror ? -1 : 1;
			character.x = sceneCharacterDirection.isMirror ? playerWitdh / 2 : -playerWitdh / 2;
			character.y = -playerHeight + 12;
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
			if(Boolean(_walkPath) && _walkPath.length > 0)
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
		
		private function playChangeStateMovie() : void
		{
			character.visible = false;
			this._spName.visible = false;
			this._face.visible = false;
			if(Boolean(this._chatBallView) && Boolean(this._chatBallView.parent))
			{
				this._chatBallView.parent.removeChild(this._chatBallView);
			}
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
			if(this._isShowPlayer == value || !this._isShowPlayer)
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
		
		public function get isReadyFight() : Boolean
		{
			return this._isReadyFight;
		}
		
		public function set isReadyFight(value:Boolean) : void
		{
			this._isReadyFight = value;
		}
		
		public function getCanAction() : Boolean
		{
			return true;
		}
		
		override public function dispose() : void
		{
			removeEventListener(SceneCharacterEvent.CHARACTER_DIRECTION_CHANGE,this.characterDirectionChange);
			ChatManager.Instance.model.removeEventListener(ChatEvent.ADD_CHAT,this.__getChat);
			ChatManager.Instance.removeEventListener(ChatEvent.SHOW_FACE,this.__getFace);
			CatchInsectMananger.instance.removeEventListener(CatchInsectEvent.CAKE_STATUS,this.__updateCakeStatus);
			if(Boolean(this._playerVO))
			{
				this._playerVO.removeEventListener(CatchInsectRoomEvent.PLAYER_POS_CHANGE,this.__onplayerPosChangeImp);
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
			if(Boolean(this._fightIcon) && Boolean(this._fightIcon.parent))
			{
				this._fightIcon.parent.removeChild(this._fightIcon);
			}
			this._fightIcon = null;
			super.dispose();
		}
	}
}

