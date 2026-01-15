package hall.player
{
	import com.pickgliss.events.FrameEvent;
	import com.pickgliss.loader.BaseLoader;
	import com.pickgliss.loader.LoadResourceManager;
	import com.pickgliss.loader.LoaderEvent;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.controls.alert.BaseAlerFrame;
	import com.pickgliss.ui.text.FilterFrameText;
	import com.pickgliss.ui.text.GradientText;
	import com.pickgliss.utils.DisplayUtils;
	import com.pickgliss.utils.ObjectUtils;
	import consortion.view.selfConsortia.Badge;
	import ddt.manager.PathManager;
	import ddt.manager.PlayerManager;
	import ddt.manager.SocketManager;
	import ddt.manager.SoundManager;
	import ddt.view.common.VipLevelIcon;
	import ddt.view.sceneCharacter.SceneCharacterDirection;
	import ddt.view.scenePathSearcher.SceneScene;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import hall.event.NewHallEvent;
	import hall.player.vo.PlayerVO;
	import newTitle.NewTitleManager;
	import newTitle.data.NewTitleModel;
	import vip.VipController;
	
	public class HallPlayer extends HallPlayerBase
	{
		
		private var _playerVO:PlayerVO;
		
		private var _currentWalkStartPoint:Point;
		
		private var _spName:Sprite;
		
		private var _lblName:FilterFrameText;
		
		private var _vipName:GradientText;
		
		private var _vipIcon:VipLevelIcon;
		
		private var _sceneScene:SceneScene;
		
		private var _badgeSprite:Sprite;
		
		private var _badge:Badge;
		
		private var _consortiaName:FilterFrameText;
		
		private var _titleSprite:Sprite;
		
		private var _title:Bitmap;
		
		private var isHiedTitle:Boolean;
		
		public function HallPlayer(playerVO:PlayerVO, callBack:Function = null)
		{
			this._playerVO = playerVO;
			this._currentWalkStartPoint = this._playerVO.playerPos;
			super(playerVO.playerInfo,callBack);
		}
		
		public function showPlayerInfo(petsDis:int) : void
		{
			_petsDis = petsDis;
			this.showVipName();
		}
		
		private function loadPets(path:String) : void
		{
			var __onLoadPetsComplete:Function = null;
			__onLoadPetsComplete = function(event:LoaderEvent):void
			{
				var loader:BaseLoader = event.loader;
				loader.removeEventListener(LoaderEvent.COMPLETE,__onLoadPetsComplete);
				_petsMovie = ComponentFactory.Instance.creat("game.living." + path);
				_petsMovie.scaleX = -1;
				_petsMovie.x = -125;
				_petsMovie.y = -27;
				addChildAt(_petsMovie,this.getChildIndex(this.character) - 1);
			};
			var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.petsAnimationPath(path),BaseLoader.MODULE_LOADER);
			loader.addEventListener(LoaderEvent.COMPLETE,__onLoadPetsComplete);
			LoadResourceManager.Instance.startLoad(loader);
		}
		
		public function showVipName() : void
		{
			var name:String = null;
			name = this.playerVO && this.playerVO.playerInfo && Boolean(this.playerVO.playerInfo.NickName) ? this.playerVO.playerInfo.NickName : "";
			moveSpeed = this._playerVO.playerMoveSpeed2;
			if(!this._spName)
			{
				this._spName = new Sprite();
			}
			addChildAt(this._spName,0);
			if(this.playerVO.playerInfo.IsVIP)
			{
				if(!this._vipName)
				{
					this._vipName = VipController.instance.getVipNameTxt(-1,this.playerVO.playerInfo.typeVIP);
					this._vipName.textSize = 16;
					this._vipName.text = name;
				}
				this._spName.addChild(this._vipName);
				DisplayUtils.removeDisplay(this._lblName);
				if(!this._vipIcon)
				{
					this._vipIcon = new VipLevelIcon();
					if(this.playerVO.playerInfo.typeVIP >= 2)
					{
						this._vipIcon.y -= 5;
					}
					this._vipIcon.setInfo(this.playerVO.playerInfo,false);
					this._spName.addChild(this._vipIcon);
					this._vipName.x = this._vipIcon.x + this._vipIcon.width;
				}
			}
			else
			{
				if(!this._lblName)
				{
					this._lblName = ComponentFactory.Instance.creat("asset.hall.playerInfo.lblName");
					this._lblName.mouseEnabled = false;
					this._lblName.text = name;
				}
				this._spName.addChild(this._lblName);
				DisplayUtils.removeDisplay(this._vipName);
			}
			var spWidth:int = Boolean(this._vipIcon) ? int(this._vipName.width + this._vipIcon.width + 8) : int(this._lblName.textWidth + 8);
			this._spName.graphics.beginFill(0,0.5);
			this._spName.graphics.drawRoundRect(-4,0,spWidth,22,5,5);
			this._spName.graphics.endFill();
			this._spName.x = -spWidth / 2;
			this._spName.y = -playerHeight + 10;
		}
		
		public function showPlayerTitle() : void
		{
			var titleModel:NewTitleModel = null;
			this.removePlayerTitle();
			if(this._playerVO.playerInfo.IsShowConsortia && this._playerVO.playerInfo.ConsortiaID > 0)
			{
				if(!this._badgeSprite)
				{
					this._badgeSprite = new Sprite();
					this._badgeSprite.y = -playerHeight - 25;
					addChild(this._badgeSprite);
				}
				if(this._playerVO.playerInfo.badgeID > 0 && !this._badge)
				{
					this._badge = new Badge();
					this._badge.badgeID = this._playerVO.playerInfo.badgeID;
					this._badge.showTip = true;
					this._badge.tipData = this._playerVO.playerInfo.ConsortiaName;
					this._badgeSprite.addChild(this._badge);
				}
				if(!this._consortiaName)
				{
					this._consortiaName = ComponentFactory.Instance.creatComponentByStylename("hall.playerInfo.consortiaName");
					this._consortiaName.text = this._playerVO.playerInfo.ConsortiaName;
					if(Boolean(this._badge))
					{
						this._consortiaName.x = 32;
					}
					this._badgeSprite.addChild(this._consortiaName);
				}
				this._badgeSprite.x = -this._badgeSprite.width / 2;
			}
			else if(this._playerVO.playerInfo.honor.length > 0)
			{
				titleModel = NewTitleManager.instance.titleInfo[this._playerVO.playerInfo.honorId];
				if(titleModel && titleModel.Show != "0" && titleModel.Pic != "0")
				{
					this.loadIcon(titleModel.Pic);
				}
			}
		}
		
		private function loadIcon(pic:String) : void
		{
			var loader:BaseLoader = LoadResourceManager.Instance.createLoader(PathManager.solvePath("image/title/" + pic + "/icon.png"),BaseLoader.BITMAP_LOADER);
			loader.addEventListener(LoaderEvent.COMPLETE,this.__onComplete);
			LoadResourceManager.Instance.startLoad(loader,true);
		}
		
		protected function __onComplete(event:LoaderEvent) : void
		{
			var loader:BaseLoader = event.loader;
			loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
			var bitmap:Bitmap = loader.content;
			if(Boolean(bitmap))
			{
				this.setTitleSprite(bitmap.bitmapData.clone());
			}
			else
			{
				this.setTitleSprite(null);
			}
		}
		
		private function setTitleSprite(bitmapdata:BitmapData) : void
		{
			if(Boolean(this._spName))
			{
				this._titleSprite = new Sprite();
				if(bitmapdata)
				{
					this._title = new Bitmap(bitmapdata);
					this._titleSprite.addChild(this._title);
				}
				this._titleSprite.x = -this._titleSprite.width / 2;
				this._titleSprite.y = this._spName.y - this._titleSprite.height - 10;
				this._titleSprite.visible = !this.isHiedTitle;
				addChild(this._titleSprite);
			}
		}
		
		public function removePlayerTitle() : void
		{
			if(Boolean(this._badgeSprite))
			{
				ObjectUtils.disposeAllChildren(this._badgeSprite);
				this._badge = null;
				this._consortiaName = null;
				this._badgeSprite = null;
			}
			if(Boolean(this._titleSprite))
			{
				ObjectUtils.disposeAllChildren(this._titleSprite);
				this._titleSprite = null;
				this._title = null;
			}
		}
		
		override protected function __onMouseClick(event:MouseEvent) : void
		{
			SoundManager.instance.playButtonSound();
			event.stopPropagation();
			if(!this._playerVO.playerInfo.isSelf)
			{
				PlayerManager.Instance.dispatchEvent(new NewHallEvent(NewHallEvent.UPDATETIPSINFO,null,[this._playerVO]));
				PlayerManager.Instance.dispatchEvent(new NewHallEvent(NewHallEvent.SETSELFPLAYERPOS,null,[event]));
			}
		}
		
		private function __onResponse(event:FrameEvent) : void
		{
			SoundManager.instance.play("008");
			var alert:BaseAlerFrame = event.target as BaseAlerFrame;
			alert.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
			alert.dispose();
			if(event.responseCode == FrameEvent.ENTER_CLICK || event.responseCode == FrameEvent.SUBMIT_CLICK)
			{
				SocketManager.Instance.out.giftPacks(this._playerVO.playerInfo.ID);
			}
		}
		
		private function characterDirectionChange(actionFlag:Boolean) : void
		{
			this._playerVO.scenePlayerDirection = sceneCharacterDirection;
			if(actionFlag)
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
				dispatchEvent(new NewHallEvent(NewHallEvent.BTNCLICK));
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
		
		public function updatePlayer() : void
		{
			this.refreshCharacterState();
			this.characterMirror();
			this.playerWalkPath();
			update();
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
			moveSpeed = this._playerVO.playerMoveSpeed2;
		}
		
		private function characterMirror() : void
		{
			var height:int = playerHeight;
			if(!isDefaultCharacter)
			{
				this.character.scaleX = sceneCharacterDirection.isMirror ? -1 : 1;
				this.character.x = sceneCharacterDirection.isMirror ? playerWidth / 2 : -playerWidth / 2;
				this.playerHitArea.scaleX = this.character.scaleX;
				this.playerHitArea.x = this.character.x;
			}
			else
			{
				this.character.scaleX = 1;
				this.character.x = -60;
				this.playerHitArea.scaleX = 1;
				this.playerHitArea.x = this.character.x;
				height = 175;
			}
			this.character.y = -height + 12;
			this.playerHitArea.y = this.character.y;
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
			var dirction:SceneCharacterDirection = null;
			var dis:Number = NaN;
			if(_walkPath != null && _tween.isPlaying && _walkPath == this._playerVO.walkPath)
			{
				return;
			}
			_walkPath = this._playerVO.walkPath;
			if(Boolean(_walkPath) && _walkPath.length > 0)
			{
				this._currentWalkStartPoint = _walkPath[0];
				dirction = this.setPlayerDirection();
				if(dirction != sceneCharacterDirection)
				{
					sceneCharacterDirection = dirction;
					updatePetsPos();
				}
				this.characterDirectionChange(true);
				dis = Point.distance(this._currentWalkStartPoint,playerPoint);
				_tween.start(dis / moveSpeed,"x",this._currentWalkStartPoint.x,"y",this._currentWalkStartPoint.y);
				_walkPath.shift();
			}
			else
			{
				this.characterDirectionChange(false);
			}
		}
		
		private function setPlayerDirection() : SceneCharacterDirection
		{
			var direction:SceneCharacterDirection = null;
			direction = SceneCharacterDirection.getDirection(playerPoint,this._currentWalkStartPoint);
			if(this._playerVO.playerInfo.IsMounts)
			{
				if(direction == SceneCharacterDirection.LT)
				{
					direction = SceneCharacterDirection.LB;
				}
				else if(direction == SceneCharacterDirection.RT)
				{
					direction = SceneCharacterDirection.RB;
				}
			}
			return direction;
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
		
		public function get playerVO() : PlayerVO
		{
			return this._playerVO;
		}
		
		public function set playerVO(value:PlayerVO) : void
		{
			this._playerVO = value;
		}
		
		public function get sceneScene() : SceneScene
		{
			return this._sceneScene;
		}
		
		public function set sceneScene(value:SceneScene) : void
		{
			this._sceneScene = value;
		}
		
		public function hideTitle(value:Boolean) : void
		{
			this.isHiedTitle = value;
			if(Boolean(this._spName))
			{
				this._spName.visible = !this.isHiedTitle;
			}
			if(Boolean(this._lblName))
			{
				this._lblName.visible = !this.isHiedTitle;
			}
			if(Boolean(this._vipName))
			{
				this._vipName.visible = !this.isHiedTitle;
			}
			if(Boolean(this._vipIcon))
			{
				this._vipIcon.visible = !this.isHiedTitle;
			}
			if(Boolean(this._badgeSprite))
			{
				this._badgeSprite.visible = !this.isHiedTitle;
			}
			if(Boolean(this._badge))
			{
				this._badge.visible = !this.isHiedTitle;
			}
			if(Boolean(this._consortiaName))
			{
				this._consortiaName.visible = !this.isHiedTitle;
			}
			if(Boolean(this._titleSprite))
			{
				this._titleSprite.visible = !this.isHiedTitle;
			}
			if(Boolean(this._title))
			{
				this._title.visible = !this.isHiedTitle;
			}
		}
		
		override public function dispose() : void
		{
			if(Boolean(this._badge))
			{
				this._badge.dispose();
				this._badge = null;
				this._badgeSprite = null;
			}
			if(Boolean(this._consortiaName))
			{
				this._consortiaName.dispose();
				this._consortiaName = null;
			}
			if(Boolean(this._playerVO))
			{
				this._playerVO = null;
			}
			if(Boolean(this._currentWalkStartPoint))
			{
				this._currentWalkStartPoint = null;
			}
			if(Boolean(this._spName))
			{
				ObjectUtils.disposeObject(this._spName);
				this._spName = null;
			}
			if(Boolean(_petsMovie))
			{
				ObjectUtils.disposeObject(_petsMovie);
				_petsMovie = null;
			}
			if(Boolean(this._lblName))
			{
				this._lblName.dispose();
				this._lblName = null;
			}
			if(Boolean(this._vipName))
			{
				this._vipName.dispose();
				this._vipName = null;
			}
			if(Boolean(this._vipIcon))
			{
				this._vipIcon.dispose();
				this._vipIcon = null;
			}
			if(Boolean(this._sceneScene))
			{
				this._sceneScene.dispose();
				this._sceneScene = null;
			}
			this.removePlayerTitle();
			ObjectUtils.disposeAllChildren(this);
			super.dispose();
		}
	}
}

