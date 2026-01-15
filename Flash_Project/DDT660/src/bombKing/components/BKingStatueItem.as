package bombKing.components
{
   import bombKing.BombKingManager;
   import bombKing.data.BKingStatueInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.BasePlayer;
   import ddt.data.player.PlayerInfo;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ShowCharacter;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import vip.VipController;
   
   public class BKingStatueItem extends Sprite implements Disposeable
   {
      
      private var _titleName:Bitmap;
      
      private var _spName:Sprite;
      
      private var _lblName:FilterFrameText;
      
      private var _vipName:GradientText;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _areaNameTxt:FilterFrameText;
      
      private var _type:int;
      
      private var _info:BKingStatueInfo;
      
      public function BKingStatueItem(type:int)
      {
         super();
         this._type = type;
         switch(this._type)
         {
            case 0:
               this._titleName = ComponentFactory.Instance.creat("asst.hall.playerTitle3");
               addChild(this._titleName);
               break;
            case 1:
               this._titleName = ComponentFactory.Instance.creat("asst.hall.playerTitle4");
               addChild(this._titleName);
               break;
            case 2:
               this._titleName = ComponentFactory.Instance.creat("asst.hall.playerTitle5");
               addChild(this._titleName);
         }
         this._titleName.x = 4;
         this._titleName.y = -44;
         this._areaNameTxt = ComponentFactory.Instance.creatComponentByStylename("hall.bombKing.areaNameTxt");
         addChild(this._areaNameTxt);
      }
      
      public function set info(info:BKingStatueInfo) : void
      {
         this._info = info;
         var playerInfo:PlayerInfo = new PlayerInfo();
         playerInfo.Style = info.style;
         playerInfo.Colors = info.color;
         playerInfo.Sex = info.sex;
         var characterLoader:ShowCharacter = CharactoryFactory.createCharacter(playerInfo) as ShowCharacter;
		 if(characterLoader)			 
		 {
			 characterLoader.addEventListener(Event.COMPLETE,this.__characterComplete);
			 characterLoader.showGun = true;
			 characterLoader.setShowLight(false,null);
			 characterLoader.stopAnimation();
			 characterLoader.show(true,1);
		 } 

         if(Boolean(info.areaName))
         {
            this._areaNameTxt.text = "(" + info.areaName + ")";
         }
      }
      
      private function createName() : void
      {
         var name:String = null;
         var playerInfo:BasePlayer = null;
         name = Boolean(this._info) && Boolean(this._info.name) ? this._info.name : "";
         if(!this._spName)
         {
            this._spName = new Sprite();
         }
         addChild(this._spName);
         if(this._info.IsVIP)
         {
            if(!this._vipName)
            {
               this._vipName = VipController.instance.getVipNameTxt(-1,this._info.vipType);
               this._vipName.textSize = 16;
               this._vipName.text = name;
            }
            this._spName.addChild(this._vipName);
            DisplayUtils.removeDisplay(this._lblName);
            if(!this._vipIcon)
            {
               this._vipIcon = new VipLevelIcon();
               if(this._info.vipType >= 2)
               {
                  this._vipIcon.y -= 5;
               }
               playerInfo = new BasePlayer();
               playerInfo.VIPLevel = this._info.vipLevel;
               playerInfo.typeVIP = this._info.vipType;
               this._vipIcon.setInfo(playerInfo,false);
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
         this._spName.x = (this.width - this._spName.width) / 2 - 16;
         this._spName.y = 0;
      }
      
      private function __characterComplete(event:Event) : void
      {
         var figure:Bitmap = null;
         var loader:ShowCharacter = event.target as ShowCharacter;
         loader.removeEventListener(Event.COMPLETE,this.__characterComplete);
         figure = new Bitmap(new BitmapData(250,320));
         figure.bitmapData.copyPixels(loader.characterBitmapdata,new Rectangle(0,0,250,320),new Point(0,0));
         figure.scaleX = 0.6;
         figure.scaleY = 0.6;
         figure.smoothing = true;
         if(BombKingManager.instance.defaultFlag)
         {
            figure.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         addChild(figure);
         this.createName();
         if(this._areaNameTxt && this._areaNameTxt.parent && this._areaNameTxt.parent.numChildren > 0)
         {
            this._areaNameTxt.parent.addChildAt(this._areaNameTxt,this._areaNameTxt.parent.numChildren - 1);
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._titleName);
         this._titleName = null;
         ObjectUtils.disposeObject(this._spName);
         this._spName = null;
         ObjectUtils.disposeObject(this._lblName);
         this._lblName = null;
         ObjectUtils.disposeObject(this._vipName);
         this._vipName = null;
         ObjectUtils.disposeObject(this._vipIcon);
         this._vipIcon = null;
      }
   }
}

