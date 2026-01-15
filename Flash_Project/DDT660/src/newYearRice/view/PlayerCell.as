package newYearRice.view
{
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
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
   import newYearRice.NewYearRiceManager;
   
   public class PlayerCell extends Sprite
   {
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      private var _directrion:String;
      
      private var _info:PlayerInfo;
      
      private var _character:ShowCharacter;
      
      private var _figure:Bitmap;
      
      private var components:Component;
      
      private var _dic:Dictionary;
      
      private var _playerID:int;
      
      private var _style:String;
      
      private var _nikeName:String;
      
      private var _sex:Boolean;
      
      public function PlayerCell()
      {
         super();
      }
      
      public function setNickName($playerID:int, $direction:String = "left", $style:String = "", $nikeName:String = "", $sex:Boolean = false) : void
      {
         NewYearRiceManager.instance.model.playerNum += 1;
         this._playerID = $playerID;
         this._directrion = $direction;
         this._style = $style;
         this._nikeName = $nikeName;
         this._sex = $sex;
         this.setInfo();
      }
      
      private function setInfo() : void
      {
         this._info = new PlayerInfo();
         if(this._playerID == PlayerManager.Instance.Self.ID)
         {
            this._info = PlayerManager.Instance.Self;
         }
         else
         {
            this._info = PlayerManager.Instance.findPlayer(this._playerID);
            this._info.Style = this._style;
            this._info.NickName = this._nikeName;
            this._info.Sex = this._sex;
         }
         if(Boolean(this._info.ID) && Boolean(this._info.Style))
         {
            this.updateCharacter();
         }
         else
         {
            SocketManager.Instance.out.sendItemEquip(this._playerID,true);
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__playerInfoChange);
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
         this._figure.width = 55;
         this._figure.height = 48;
         if(this._info != null)
         {
            this.components = NewYearRiceManager.instance.returnComponent(this._figure,LanguageMgr.GetTranslation("asset.playerCell.tip",this._info.NickName));
            this.components.scaleX = this._directrion == LEFT ? 1 : -1;
            addChild(this.components);
         }
      }
      
      public function dispose() : void
      {
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get playerID() : int
      {
         return this._playerID;
      }
      
      public function get info() : PlayerInfo
      {
         return this._info;
      }
      
      public function removePlayerCell() : void
      {
         if(Boolean(this._info))
         {
            ObjectUtils.disposeObject(this._info);
            this._info = null;
         }
         if(Boolean(this.components))
         {
            ObjectUtils.disposeObject(this.components);
            this.components = null;
         }
         this._directrion = "";
         this._style = "";
         this._nikeName = "";
      }
      
      public function set info(value:PlayerInfo) : void
      {
         this._info = value;
      }
      
      public function get nikeName() : String
      {
         return this._nikeName;
      }
      
      public function set nikeName(value:String) : void
      {
         this._nikeName = value;
      }
   }
}

