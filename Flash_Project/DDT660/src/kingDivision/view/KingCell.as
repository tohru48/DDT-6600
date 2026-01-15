package kingDivision.view
{
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.ShowCharacter;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import kingDivision.KingDivisionManager;
   import kingDivision.data.KingDivisionConsortionItemInfo;
   
   public class KingCell extends Sprite implements Disposeable
   {
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      public var _playerInfo:KingDivisionConsortionItemInfo;
      
      private var _info:PlayerInfo;
      
      private var _character:ShowCharacter;
      
      private var _figure:Bitmap;
      
      private var _directrion:String;
      
      private var _consortionName:String;
      
      private var _index:int;
      
      private var components:Component;
      
      private var _dic:Dictionary;
      
      public function KingCell()
      {
         super();
         this._dic = KingDivisionManager.Instance.dataDic;
      }
      
      public function setNickName(playerInfo:KingDivisionConsortionItemInfo, direction:String = "left") : void
      {
         if(this._playerInfo == null)
         {
            this._playerInfo = playerInfo;
            this._directrion = direction;
            this.setInfo();
            return;
         }
         if(KingDivisionManager.Instance.zoneIndex != 0)
         {
            this.tipUpdate();
         }
      }
      
      private function setInfo() : void
      {
         this._info = new PlayerInfo();
         if(KingDivisionManager.Instance.states == 2 && !KingDivisionManager.Instance.isThisZoneWin)
         {
            this._info.Style = this._playerInfo.consortionStyle;
            this._info.Sex = this._playerInfo.consortionSex;
            if(Boolean(this._info.Style))
            {
               this.updateCharacter();
            }
         }
         else
         {
            if(this._playerInfo.name == PlayerManager.Instance.Self.NickName)
            {
               this._info = PlayerManager.Instance.Self;
            }
            else
            {
               this._info = PlayerManager.Instance.findPlayerByNickName(this._info,this._playerInfo.name);
            }
            if(KingDivisionManager.Instance.isThisZoneWin)
            {
               this._info.Style = this._playerInfo.conStyle;
               this._info.Sex = this._playerInfo.conSex;
               if(Boolean(this._info.Style))
               {
                  this.updateCharacter();
               }
            }
            else if(Boolean(this._info.ID) && Boolean(this._info.Style))
            {
               this.updateCharacter();
            }
            else
            {
               SocketManager.Instance.out.sendItemEquip(this._playerInfo.name,true);
               this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
            }
         }
      }
      
      private function __playerInfoChange(event:PlayerPropertyEvent) : void
      {
         this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
         this.updateCharacter();
      }
      
      private function updateCharacter() : void
      {
         if(Boolean(this._character))
         {
            this._character.removeEventListener(Event.COMPLETE,this.__characterComplete);
            this._character.dispose();
            this._character = null;
         }
         if(this._figure && this._figure.parent && Boolean(this._figure.bitmapData))
         {
            this._figure.parent.removeChild(this._figure);
            this._figure.bitmapData.dispose();
            this._figure = null;
         }
         this._character = CharactoryFactory.createCharacter(this._info) as ShowCharacter;
         this._character.addEventListener(Event.COMPLETE,this.__characterComplete);
         this._character.showGun = false;
         this._character.setShowLight(false,null);
         this._character.stopAnimation();
         this._character.show(true,1);
         this._character.buttonMode = this._character.mouseEnabled = this._character.mouseEnabled = false;
      }
      
      private function __characterComplete(evt:Event) : void
      {
         if(this._figure && this._figure.parent && Boolean(this._figure.bitmapData))
         {
            this._figure.parent.removeChild(this._figure);
            this._figure.bitmapData.dispose();
            this._figure = null;
         }
         if(!this._character.info.getShowSuits())
         {
            this._figure = new Bitmap(new BitmapData(200,150));
            this._figure.bitmapData.copyPixels(this._character.characterBitmapdata,new Rectangle(0,60,200,150),new Point(0,0));
         }
         else
         {
            this._figure = new Bitmap(new BitmapData(200,200));
            this._figure.bitmapData.copyPixels(this._character.characterBitmapdata,new Rectangle(0,10,200,200),new Point(0,0));
         }
         this._figure.width = 42;
         this._figure.height = 36;
         if(KingDivisionManager.Instance.zoneIndex == 0)
         {
            this.components = KingDivisionManager.Instance.returnComponent(this._figure,LanguageMgr.GetTranslation("asset.kingCell.tip",this._playerInfo.conName,this._playerInfo.score));
         }
         else if(this._dic == null)
         {
            this.components = KingDivisionManager.Instance.returnComponent(this._figure,LanguageMgr.GetTranslation("asset.kingCell.tip",this._playerInfo.consortionNameArea,this._playerInfo.consortionScoreArea));
         }
         else
         {
            this.components = KingDivisionManager.Instance.returnComponent(this._figure,LanguageMgr.GetTranslation("asset.kingCell.tipArea",this._playerInfo.consortionNameArea,this._playerInfo.consortionScoreArea,this._dic[this._playerInfo.areaID]));
         }
         this.components.scaleX = this._directrion == LEFT ? 1 : -1;
         addChild(this.components);
      }
      
      private function tipUpdate() : void
      {
         var figure:Bitmap = null;
         figure = new Bitmap(new BitmapData(200,200));
         figure.width = 42;
         figure.height = 36;
         figure.visible = false;
         if(this._dic == null)
         {
            this.components = KingDivisionManager.Instance.returnComponent(this._figure,LanguageMgr.GetTranslation("asset.kingCell.tip",this._playerInfo.consortionNameArea,this._playerInfo.consortionScoreArea));
         }
         else
         {
            this.components = KingDivisionManager.Instance.returnComponent(this._figure,LanguageMgr.GetTranslation("asset.kingCell.tipArea",this._playerInfo.consortionNameArea,this._playerInfo.consortionScoreArea,this._dic[this._playerInfo.areaID]));
         }
         this.components.scaleX = this._directrion == LEFT ? 1 : -1;
         addChild(this.components);
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(value:int) : void
      {
         this._index = value;
      }
      
      public function dispose() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

