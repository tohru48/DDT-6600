package auctionHouse.view
{
   import auctionHouse.event.AuctionHouseEvent;
   import auctionHouse.model.AuctionHouseModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleDropListTarget;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.CateCoryInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class BrowseLeftMenuView extends Sprite implements Disposeable
   {
      
      private static const ALL:int = -1;
      
      private static const WEAPON:int = 25;
      
      private static const SUB_WEAPON:int = 7;
      
      private static const OFFHAND:int = 17;
      
      private static const CLOTH:int = 21;
      
      private static const HAT:int = 1;
      
      private static const GLASS:int = 2;
      
      private static const SUB_CLOTH:int = 5;
      
      private static const JEWELRY:int = 24;
      
      private static const BEAUTY:int = 22;
      
      private static const HAIR:int = 3;
      
      private static const ORNAMENT:int = 4;
      
      private static const EYES:int = 6;
      
      private static const SUITS:int = 13;
      
      private static const WINGS:int = 15;
      
      private static const STRENTH:int = 1100;
      
      private static const STRENTH_1:int = 11025;
      
      private static const STRENTH_2:int = 1102;
      
      private static const STRENTH_3:int = 1103;
      
      private static const STRENTH_4:int = 1104;
      
      private static const STRENTH_5:int = 1110;
      
      private static const COMPOSE:int = 1105;
      
      private static const ZHUQUE:int = 1106;
      
      private static const XUANWU:int = 1107;
      
      private static const QINGLONG:int = 1108;
      
      private static const BAIHU:int = 1109;
      
      private static const SPHERE:int = 26;
      
      private static const TRIANGLE:int = 27;
      
      private static const ROUND:int = 28;
      
      private static const SQUERE:int = 29;
      
      private static const WISHBEAD:int = 35;
      
      private static const Drill:int = 1115;
      
      private static const DrillLv1:int = 1116;
      
      private static const DrillLv2:int = 1117;
      
      private static const DrillLv3:int = 1118;
      
      private static const DrillLv4:int = 1119;
      
      private static const DrillLv5:int = 1120;
      
      private static const PATCH:int = 30;
      
      private static const WUQISP:int = 1111;
      
      private static const FUWUQISP:int = 1112;
      
      private static const XIANGLIANSP:int = 1121;
      
      private static const CARDS:int = 31;
      
      private static const FREAKCARD:int = 1113;
      
      private static const EQUIPCARD:int = 1114;
      
      private static const PROP:int = 23;
      
      private static const UNFIGHT_PROP:int = 11;
      
      private static const PAOPAO:int = 16;
      
      private static const PET:int = 36;
      
      private static const UNBINDPET:int = 37;
      
      private static const PETEQUIP:int = 38;
      
      private static const PETSTONE:int = 39;
      
      private var menu:VerticalMenu;
      
      private var list:ScrollPanel;
      
      private var _name:SimpleDropListTarget;
      
      private var searchStatus:Boolean;
      
      private var _searchBtn:TextButton;
      
      private var _WuqiFont:ScaleFrameImage;
      
      private var _searchValue:String;
      
      private var _glowState:Boolean;
      
      private var _isForAll:Boolean = true;
      
      private var _isFindAll:Boolean = false;
      
      public function BrowseLeftMenuView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var bg1:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.LeftBG1");
         addChild(bg1);
         var inputBg:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("asset.auctionHouse.Browse.baiduBG");
         addChild(inputBg);
         this._searchBtn = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.baidu_btn");
         this._searchBtn.text = LanguageMgr.GetTranslation("shop.ShopRankingView.SearchBtnText");
         addChild(this._searchBtn);
         this._name = ComponentFactory.Instance.creat("auctionHouse.baiduText");
         this._searchValue = "";
         this._name.maxChars = 20;
         addChild(this._name);
         this.list = ComponentFactory.Instance.creat("auctionHouse.BrowseLeftScrollpanel");
         addChild(this.list);
         this.list.hScrollProxy = ScrollPanel.OFF;
         this.list.vScrollProxy = ScrollPanel.ON;
         this.menu = new VerticalMenu(11,45,33);
         this.list.setView(this.menu);
      }
      
      private function menuRefrash(event:Event) : void
      {
         this._isFindAll = ((event.currentTarget as VerticalMenu).currentItem as BrowseLeftMenuItem).isOpen;
         this.list.invalidateViewport();
      }
      
      private function addEvent() : void
      {
         this._name.addEventListener(MouseEvent.MOUSE_DOWN,this._clickName);
         this._name.addEventListener(Event.CHANGE,this._nameChange);
         this._name.addEventListener(KeyboardEvent.KEY_UP,this._nameKeyUp);
         this._name.addEventListener(Event.ADDED_TO_STAGE,this.setFocus);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__searchCondition);
         this.menu.addEventListener(VerticalMenu.MENU_CLICKED,this.menuItemClick);
         this.menu.addEventListener(VerticalMenu.MENU_REFRESH,this.menuRefrash);
      }
      
      private function removeEvent() : void
      {
         this._name.removeEventListener(MouseEvent.MOUSE_DOWN,this._clickName);
         this._name.removeEventListener(Event.CHANGE,this._nameChange);
         this._name.removeEventListener(KeyboardEvent.KEY_UP,this._nameKeyUp);
         this._name.removeEventListener(Event.ADDED_TO_STAGE,this.setFocus);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__searchCondition);
         this.menu.removeEventListener(VerticalMenu.MENU_CLICKED,this.menuItemClick);
         this.menu.removeEventListener(VerticalMenu.MENU_REFRESH,this.menuRefrash);
      }
      
      private function _clickName(e:MouseEvent) : void
      {
         if(this._name.text == LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere"))
         {
            this._name.text = "";
         }
      }
      
      private function setFocus(evt:Event) : void
      {
         this._name.text = LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere");
         this._searchValue = "";
         this._name.setFocus();
         this._name.setCursor(this._name.text.length);
      }
      
      public function setFocusName() : void
      {
         this._name.setFocus();
      }
      
      internal function getInfo() : CateCoryInfo
      {
         if(this._isForAll)
         {
            return this.getMainCateInfo(ALL,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.All"));
         }
         if(Boolean(this.menu.currentItem))
         {
            return this.menu.currentItem.info as CateCoryInfo;
         }
         return this.getMainCateInfo(ALL,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.All"));
      }
      
      internal function setSelectType(type:CateCoryInfo) : void
      {
      }
      
      internal function getType() : int
      {
         if(this._isForAll)
         {
            return -1;
         }
         if(Boolean(this.menu.currentItem))
         {
            return this.menu.currentItem.info.ID;
         }
         return -1;
      }
      
      internal function setCategory(value:Vector.<CateCoryInfo>) : void
      {
         var info:CateCoryInfo = null;
         var jewelry:CateCoryInfo = null;
         var jewelryItem:BrowseLeftMenuItem = null;
         var subWeapon:CateCoryInfo = null;
         var subWeaponItem:BrowseLeftMenuItem = null;
         var offHand:CateCoryInfo = null;
         var offHandItem:BrowseLeftMenuItem = null;
         var subItem1:BrowseLeftMenuItem = null;
         var subItem6:BrowseLeftMenuItem = null;
         var subItem7:BrowseLeftMenuItem = null;
         var subItem8:BrowseLeftMenuItem = null;
         var subItem9:BrowseLeftMenuItem = null;
         var subItem10:BrowseLeftMenuItem = null;
         var subItem11:BrowseLeftMenuItem = null;
         var subItem19:BrowseLeftMenuItem = null;
         var subItem12:BrowseLeftMenuItem = null;
         var subItem13:BrowseLeftMenuItem = null;
         var subItemPet1:BrowseLeftMenuItem = null;
         var subItemPet2:BrowseLeftMenuItem = null;
         var subItemPet3:BrowseLeftMenuItem = null;
         var triangle:CateCoryInfo = null;
         var triangleItem:BrowseLeftMenuItem = null;
         var round:CateCoryInfo = null;
         var roundItem:BrowseLeftMenuItem = null;
         var square:CateCoryInfo = null;
         var squareItem:BrowseLeftMenuItem = null;
         var wishBead:CateCoryInfo = null;
         var wishBeadItem:BrowseLeftMenuItem = null;
         var subItem14:BrowseLeftMenuItem = null;
         var subItem15:BrowseLeftMenuItem = null;
         var subItem16:BrowseLeftMenuItem = null;
         var subItem17:BrowseLeftMenuItem = null;
         var subItem18:BrowseLeftMenuItem = null;
         var item:BrowseLeftMenuItem = null;
         var item0:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.fuzhuang")),this.getMainCateInfo(CLOTH,LanguageMgr.GetTranslation("")));
         var item1:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.meirong")),this.getMainCateInfo(BEAUTY,LanguageMgr.GetTranslation("")));
         var item2:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.prop")),this.getMainCateInfo(PROP,LanguageMgr.GetTranslation("")));
         var item4:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.weapon")),this.getMainCateInfo(WEAPON,LanguageMgr.GetTranslation("")));
         var item5:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.qianghuahecheng")),this.getMainCateInfo(STRENTH,LanguageMgr.GetTranslation("")));
         var item7:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.baozhuzuantou")),this.getMainCateInfo(SPHERE,LanguageMgr.GetTranslation("")));
         var item8:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.xycp")),this.getMainCateInfo(PATCH,LanguageMgr.GetTranslation("")));
         var item9:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.cards")),this.getMainCateInfo(CARDS,LanguageMgr.GetTranslation("")));
         var item11:BrowseLeftMenuItem = new BrowseLeftMenuItem(new BrowserLeftStripAsset(ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.pets")),this.getMainCateInfo(PET,LanguageMgr.GetTranslation("")));
         var _Weapon:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.Weapon");
         var _Cloth:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.cloth");
         var _beauty:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.beauty");
         var _qianghuahecheng:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauction.qianghuahechengIcon");
         var _hechengshi:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauction.hechengshi");
         var _sphere:Bitmap = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.sphere");
         var _drill:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.drill");
         var _rarechip:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.rarechip");
         var _cards:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.cards");
         var _prop:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.prop");
         var _pet:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtauctionHouse.petIcon");
         this.menu.addItemAt(item4,-1);
         this.menu.addItemAt(item0,-1);
         this.menu.addItemAt(item1,-1);
         this.menu.addItemAt(item5,-1);
         this.menu.addItemAt(item7,-1);
         this.menu.addItemAt(item8,-1);
         this.menu.addItemAt(item9,-1);
         this.menu.addItemAt(item2,-1);
         this.menu.addItemAt(item11,-1);
         item4.addChild(_Weapon);
         item0.addChild(_Cloth);
         item1.addChild(_beauty);
         item5.addChild(_qianghuahecheng);
         item7.addChild(_sphere);
         item8.addChild(_rarechip);
         item9.addChild(_cards);
         item2.addChild(_prop);
         item11.addChild(_pet);
         for each(info in value)
         {
            if(info.ID == HAT || info.ID == GLASS || info.ID == SUB_CLOTH)
            {
               item = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),info);
               this.menu.addItemAt(item,1);
            }
            else if(info.ID == SUITS || info.ID == WINGS || info.ID == EYES || info.ID == ORNAMENT || info.ID == HAIR)
            {
               item = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),info);
               this.menu.addItemAt(item,2);
            }
            else if(info.ID == UNFIGHT_PROP || info.ID == PAOPAO)
            {
               item = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),info);
               this.menu.addItemAt(item,7);
            }
            else
            {
               item = null;
            }
         }
         jewelry = new CateCoryInfo();
         jewelry.ID = JEWELRY;
         jewelry.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.jewelry");
         jewelryItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),jewelry);
         this.menu.addItemAt(jewelryItem,1);
         subWeapon = new CateCoryInfo();
         subWeapon.ID = SUB_WEAPON;
         subWeapon.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.Weapon");
         subWeaponItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),subWeapon);
         this.menu.addItemAt(subWeaponItem,0);
         offHand = new CateCoryInfo();
         offHand.ID = OFFHAND;
         offHand.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.offhand");
         offHandItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),offHand);
         this.menu.addItemAt(offHandItem,0);
         subItem1 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(STRENTH_1,LanguageMgr.GetTranslation("tank.auctionHouse.view.BrowseLeftMenuView.qianghua")));
         this.menu.addItemAt(subItem1,3);
         subItem6 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(ZHUQUE,LanguageMgr.GetTranslation("BrowseLeftMenuView.zhuque")));
         subItem7 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(XUANWU,LanguageMgr.GetTranslation("BrowseLeftMenuView.xuanwu")));
         subItem8 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(QINGLONG,LanguageMgr.GetTranslation("BrowseLeftMenuView.qinglong")));
         subItem9 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(BAIHU,LanguageMgr.GetTranslation("BrowseLeftMenuView.baihu")));
         this.menu.addItemAt(subItem6,3);
         this.menu.addItemAt(subItem7,3);
         this.menu.addItemAt(subItem8,3);
         this.menu.addItemAt(subItem9,3);
         subItem10 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(WUQISP,LanguageMgr.GetTranslation("BrowseLeftMenuView.wuqisp")));
         subItem11 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(FUWUQISP,LanguageMgr.GetTranslation("BrowseLeftMenuView.fuwuqisp")));
         subItem19 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(XIANGLIANSP,LanguageMgr.GetTranslation("BrowseLeftMenuView.xiangliansp")));
         this.menu.addItemAt(subItem19,5);
         this.menu.addItemAt(subItem10,5);
         this.menu.addItemAt(subItem11,5);
         subItem12 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(FREAKCARD,LanguageMgr.GetTranslation("BrowseLeftMenuView.freakCard")));
         subItem13 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(EQUIPCARD,LanguageMgr.GetTranslation("BrowseLeftMenuView.equipCard")));
         this.menu.addItemAt(subItem12,6);
         this.menu.addItemAt(subItem13,6);
         subItemPet1 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(UNBINDPET,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.PetTxt1")));
         subItemPet2 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(PETEQUIP,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.PetTxt2")));
         subItemPet3 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(PETSTONE,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.PetTxt3")));
         this.menu.addItemAt(subItemPet1,8);
         this.menu.addItemAt(subItemPet2,8);
         this.menu.addItemAt(subItemPet3,8);
         triangle = new CateCoryInfo();
         triangle.ID = TRIANGLE;
         triangle.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.triangle");
         triangleItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),triangle);
         this.menu.addItemAt(triangleItem,4);
         round = new CateCoryInfo();
         round.ID = ROUND;
         round.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.round");
         roundItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),round);
         this.menu.addItemAt(roundItem,4);
         square = new CateCoryInfo();
         square.ID = SQUERE;
         square.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.square");
         squareItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),square);
         this.menu.addItemAt(squareItem,4);
         wishBead = new CateCoryInfo();
         wishBead.ID = WISHBEAD;
         wishBead.Name = LanguageMgr.GetTranslation("tank.auctionHouse.view.wishBead");
         wishBeadItem = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),wishBead);
         this.menu.addItemAt(wishBeadItem,4);
         subItem14 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv1,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv1 - Drill)));
         subItem15 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv2,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv2 - Drill)));
         subItem16 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv3,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv3 - Drill)));
         subItem17 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv4,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv4 - Drill)));
         subItem18 = new BrowseLeftMenuItem(new BrowserLeftSubStripAsset(),this.getMainCateInfo(DrillLv5,LanguageMgr.GetTranslation("tank.view.bagII.GoodsTipPanel.drillnote",DrillLv5 - Drill)));
         this.menu.addItemAt(subItem14,4);
         this.menu.addItemAt(subItem15,4);
         this.menu.addItemAt(subItem16,4);
         this.menu.addItemAt(subItem17,4);
         this.menu.addItemAt(subItem18,4);
         this.list.invalidateViewport();
      }
      
      private function getMainCateInfo(id:int, name:String) : CateCoryInfo
      {
         var info:CateCoryInfo = new CateCoryInfo();
         info.ID = id;
         info.Name = name;
         return info;
      }
      
      private function _nameKeyUp(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.ENTER)
         {
            AuctionHouseModel._dimBooble = false;
            if(!this._isFindAll)
            {
               this.__searchGoods(true);
               return;
            }
            this.__searchGoods(false);
         }
      }
      
      private function _nameChange(e:Event) : void
      {
         if(this._name.text.indexOf(LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere")) > -1)
         {
            this._name.text = this._name.text.replace(LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere"),"");
         }
      }
      
      public function get searchText() : String
      {
         return this._searchValue;
      }
      
      public function set setSearchStatus(b:Boolean) : void
      {
         this.searchStatus = b;
      }
      
      public function set searchText(s:String) : void
      {
         this._name.text = s;
         this._searchValue = s;
      }
      
      private function __searchCondition(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         AuctionHouseModel._dimBooble = false;
         if(!this._isFindAll)
         {
            this.__searchGoods(true);
            return;
         }
         this.__searchGoods(false);
      }
      
      private function __searchGoods(isForAll:Boolean = false) : void
      {
         this._isForAll = isForAll;
         AuctionHouseModel._dimBooble = false;
         if(this._name.text == LanguageMgr.GetTranslation("tank.auctionHouse.view.pleaseInputOnThere"))
         {
            this._name.text = "";
         }
         this._searchValue = "";
         this._name.text = this._trim(this._name.text);
         this._searchValue = this._name.text;
         AuctionHouseModel.searchType = 2;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
      }
      
      private function __searchGoodsII(isForAll:Boolean = false) : void
      {
         this._isForAll = isForAll;
         AuctionHouseModel._dimBooble = false;
         this._searchValue = "";
         AuctionHouseModel.searchType = 2;
         dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
      }
      
      private function _trim(str:String) : String
      {
         if(!str)
         {
            return str;
         }
         return str.replace(/(^\s*)|(\s*$)/g,"");
      }
      
      private function menuItemClick(e:Event) : void
      {
         this.list.invalidateViewport();
         if(this.menu.isseach)
         {
            AuctionHouseModel._dimBooble = false;
            this.__searchGoodsII();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(Boolean(this._searchBtn))
         {
            this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__searchCondition);
         }
         if(Boolean(this.menu))
         {
            this.menu.removeEventListener(VerticalMenu.MENU_CLICKED,this.menuItemClick);
            this.menu.dispose();
            this.menu = null;
         }
         if(Boolean(this.list))
         {
            ObjectUtils.disposeObject(this.list);
            this.list = null;
         }
         if(Boolean(this._name))
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(Boolean(this._searchBtn))
         {
            ObjectUtils.disposeObject(this._searchBtn);
         }
         this._searchBtn = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

