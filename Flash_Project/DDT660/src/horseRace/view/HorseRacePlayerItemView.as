package horseRace.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import ddt.view.sceneCharacter.SceneCharacterLoaderHead;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HorseRacePlayerItemView extends Sprite implements Disposeable
   {
      
      private static var HeadWidth:int = 120;
      
      private static var HeadHeight:int = 103;
      
      private var _selectbg:Bitmap;
      
      private var _isSelf:Boolean;
      
      private var _headBg:Bitmap;
      
      private var _rakeImg:MovieClip;
      
      private var _playerNameTxt:FilterFrameText;
      
      private var _spName:Sprite;
      
      private var _lblName:FilterFrameText;
      
      private var _walkingPlayer:HorseRaceWalkPlayer;
      
      private var _headLoader:SceneCharacterLoaderHead;
      
      private var _headBitmap:Bitmap;
      
      private var _clickSp:Sprite;
      
      private var _buffList:HBox;
      
      private var _pingzhangBuff:MovieClip;
      
      public function HorseRacePlayerItemView(walkingPlayer:HorseRaceWalkPlayer)
      {
         super();
         this._walkingPlayer = walkingPlayer;
         this.initView();
         this.loadHead();
         this.initEvent();
      }
      
      public function getPlayerInfo() : HorseRaceWalkPlayer
      {
         return this._walkingPlayer;
      }
      
      private function initView() : void
      {
         this._selectbg = ComponentFactory.Instance.creat("horseRace.raceView.playerItemSelectBg");
         this._spName = new Sprite();
         this._lblName = ComponentFactory.Instance.creat("asset.hall.playerInfo.lblName");
         this._lblName.mouseEnabled = false;
         this._lblName.text = this._walkingPlayer.playerVO.playerInfo.NickName;
         var spWidth:int = this._lblName.textWidth + 8;
         this._spName.graphics.beginFill(0,0.5);
         this._spName.graphics.drawRoundRect(-4,0,spWidth,22,5,5);
         this._spName.graphics.endFill();
         this._spName.addChild(this._lblName);
         PositionUtils.setPos(this._spName,"horseRace.raceView.playerItemNamePos");
         this._rakeImg = ComponentFactory.Instance.creat("horseRace.raceView.playerRaceMc");
         PositionUtils.setPos(this._rakeImg,"horseRace.raceView.playerRankPos");
         if(this._walkingPlayer.isSelf)
         {
            this._headBg = ComponentFactory.Instance.creat("horseRace.raceView.selfplayerBg");
         }
         else
         {
            this._headBg = ComponentFactory.Instance.creat("horseRace.raceView.otherplayerBg");
         }
         this._clickSp = new Sprite();
         this._clickSp.x = this._selectbg.x;
         this._clickSp.y = this._selectbg.y;
         this._clickSp.graphics.beginFill(0,0);
         this._clickSp.graphics.drawRect(0,0,this._selectbg.width,this._selectbg.height);
         this._clickSp.graphics.endFill();
         addChild(this._clickSp);
         addChild(this._selectbg);
         this._selectbg.visible = false;
         this._buffList = ComponentFactory.Instance.creatComponentByStylename("horseRace.raceView.buffList");
         addChild(this._buffList);
         this._pingzhangBuff = ComponentFactory.Instance.creat("horseRaceView.pingzhangHaveBuff");
         PositionUtils.setPos(this._pingzhangBuff,"horseRace.raceView.pingzhangBuffPos");
      }
      
      public function setBgVisible(bool:Boolean) : void
      {
         this._selectbg.visible = bool;
      }
      
      public function flashBuffList(buffArr:Array) : void
      {
         var buffTIP:Bitmap = null;
         var isHavePingzhang:Boolean = false;
         this._buffList.removeAllChild();
         for(var i:int = 0; i < buffArr.length; i++)
         {
            if(buffArr[i] == 8)
            {
               isHavePingzhang = true;
            }
            buffTIP = this.getBuffByType(buffArr[i]);
            this._buffList.addChild(buffTIP);
         }
         this.flushRank();
         this.showPingzhangBuff(isHavePingzhang);
      }
      
      public function flushRank() : void
      {
         this._rakeImg.gotoAndStop(this._walkingPlayer.rank);
      }
      
      public function showPingzhangBuff(bool:Boolean) : void
      {
         if(bool)
         {
            this._pingzhangBuff.visible = true;
         }
         else
         {
            this._pingzhangBuff.visible = false;
         }
      }
      
      private function getBuffByType(type:int) : Bitmap
      {
         var buff:Bitmap = null;
         if(type == 1)
         {
            buff = ComponentFactory.Instance.creat("horseRace.raceView.buff1");
         }
         else if(type == 2)
         {
            buff = ComponentFactory.Instance.creat("horseRace.raceView.buff2");
         }
         else if(type == 3)
         {
            buff = ComponentFactory.Instance.creat("horseRace.raceView.buff3");
         }
         else if(type == 4)
         {
            buff = ComponentFactory.Instance.creat("horseRace.raceView.buff3");
         }
         else if(type == 5)
         {
            buff = ComponentFactory.Instance.creat("horseRace.raceView.buff5");
         }
         else if(type == 6)
         {
            buff = ComponentFactory.Instance.creat("horseRace.raceView.buff6");
         }
         else if(type == 7)
         {
            buff = ComponentFactory.Instance.creat("horseRace.raceView.buff7");
         }
         else if(type == 8)
         {
            buff = ComponentFactory.Instance.creat("horseRace.raceView.buff8");
         }
         buff.width = 16;
         buff.height = 16;
         return buff;
      }
      
      public function loadHead() : void
      {
         if(Boolean(this._headLoader))
         {
            this._headLoader.dispose();
            this._headLoader = null;
         }
         this._headLoader = new SceneCharacterLoaderHead(this._walkingPlayer.playerVO.playerInfo);
         this._headLoader.load(this.headLoaderCallBack);
      }
      
      private function headLoaderCallBack(headLoader:SceneCharacterLoaderHead, isAllLoadSucceed:Boolean = true) : void
      {
         var rectangle:Rectangle = null;
         var headBmp:BitmapData = null;
         if(Boolean(headLoader))
         {
            if(!this._headBitmap)
            {
               this._headBitmap = new Bitmap();
            }
            rectangle = new Rectangle(0,0,HeadWidth,HeadHeight);
            headBmp = new BitmapData(HeadWidth,HeadHeight,true,0);
            headBmp.copyPixels(headLoader.getContent()[0] as BitmapData,rectangle,new Point(0,0));
            this._headBitmap.bitmapData = headBmp;
            headLoader.dispose();
            this._headBitmap.rotationY = 180;
            if(this._walkingPlayer.isSelf)
            {
               this._headBitmap.width = 62;
               this._headBitmap.height = 52;
               PositionUtils.setPos(this._headBitmap,"horseRace.raceView.playerSelfImgPos");
            }
            else
            {
               this._headBitmap.width = 52;
               this._headBitmap.height = 42;
               PositionUtils.setPos(this._headBitmap,"horseRace.raceView.playerOtherImgPos");
            }
            this._rakeImg.gotoAndStop(this._walkingPlayer.rank);
            addChild(this._spName);
            addChild(this._headBg);
            addChild(this._headBitmap);
            addChild(this._rakeImg);
            addChild(this._pingzhangBuff);
            this.showPingzhangBuff(false);
         }
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
      }
   }
}

