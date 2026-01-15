package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import tofflist.data.TofflistLayoutInfo;
   
   public class TofflistGridBox extends Sprite implements Disposeable
   {
      
      private static const RANK:String = LanguageMgr.GetTranslation("repute");
      
      private static const NAME:String = LanguageMgr.GetTranslation("civil.rightview.listname");
      
      private static const BATTLE:String = LanguageMgr.GetTranslation("tank.menu.FightPoweTxt");
      
      private static const LEVEL:String = LanguageMgr.GetTranslation("tank.menu.LevelTxt");
      
      private static const EXP:String = LanguageMgr.GetTranslation("exp");
      
      private static const CHARM_LEVEL:String = LanguageMgr.GetTranslation("tofflist.charmLevel");
      
      private static const CHARM_VALUE:String = LanguageMgr.GetTranslation("ddt.giftSystem.GiftGoodItem.charmNum");
      
      private static const SCORE:String = LanguageMgr.GetTranslation("tofflist.battleScore");
      
      private static const ACHIVE_POINT:String = LanguageMgr.GetTranslation("tofflist.achivepoint");
      
      private static const ASSET:String = LanguageMgr.GetTranslation("consortia.Money");
      
      private static const TOTAL_ASSET:String = LanguageMgr.GetTranslation("tofflist.totalasset");
      
      private static const SERVER:String = LanguageMgr.GetTranslation("tofflist.server");
      
      private static const MOUNTSNAME:String = LanguageMgr.GetTranslation("tofflist.mountsname");
      
      private static const MOUNTSLEVEL:String = LanguageMgr.GetTranslation("tofflist.mountslevel");
      
      private static const MOUNTSHOST:String = LanguageMgr.GetTranslation("tofflist.mountshost");
      
      private var _bg:MutipleImage;
      
      private var _titleBg:MutipleImage;
      
      private var _layoutInfoArr:Dictionary;
      
      private var _title:Sprite;
      
      private var _orderList:TofflistOrderList;
      
      private var _id:String;
      
      public function TofflistGridBox()
      {
         super();
         this._layoutInfoArr = new Dictionary();
         this.initData();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("tofflist.right.listBg");
         addChild(this._bg);
         this._title = new Sprite();
         this._title.y = 2;
         addChild(this._title);
         this._orderList = new TofflistOrderList();
         PositionUtils.setPos(this._orderList,"tofflist.orderlistPos");
         addChild(this._orderList);
      }
      
      private function initData() : void
      {
         var person_local_battle:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_battle");
         person_local_battle.TitleTextString = [RANK,NAME,BATTLE];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_BATTLE] = person_local_battle;
         var person_local_level:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_level");
         person_local_level.TitleTextString = [RANK,NAME,LEVEL,EXP];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_LEVEL] = person_local_level;
         var person_local_achive:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_achive");
         person_local_achive.TitleTextString = [RANK,NAME,ACHIVE_POINT];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_ACHIVE] = person_local_achive;
         var person_local_charm:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_charm");
         person_local_charm.TitleTextString = [RANK,NAME,CHARM_LEVEL,CHARM_VALUE];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_CHARM] = person_local_charm;
         var person_local_match:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_match");
         person_local_match.TitleTextString = [RANK,NAME,SCORE];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_MATCH] = person_local_match;
         var person_local_mounts:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_local_mounts");
         person_local_mounts.TitleTextString = [RANK,MOUNTSNAME,MOUNTSLEVEL,MOUNTSHOST];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_LOCAL_MOUNTS] = person_local_mounts;
         var person_cross_battle:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_cross_battle");
         person_cross_battle.TitleTextString = [RANK,NAME,SERVER,BATTLE];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_CROSS_BATTLE] = person_cross_battle;
         var person_cross_level:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_cross_level");
         person_cross_level.TitleTextString = [RANK,NAME,LEVEL,SERVER,EXP];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_CROSS_LEVEL] = person_cross_level;
         var person_cross_achive:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_cross_achive");
         person_cross_achive.TitleTextString = [RANK,NAME,SERVER,ACHIVE_POINT];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_CROSS_ACHIVE] = person_cross_achive;
         var person_cross_charm:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_cross_charm");
         person_cross_charm.TitleTextString = [RANK,NAME,CHARM_LEVEL,SERVER,CHARM_VALUE];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_CROSS_CHARM] = person_cross_charm;
         var person_cross_mounts:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("person_cross_mounts");
         person_cross_mounts.TitleTextString = [RANK,MOUNTSNAME,MOUNTSLEVEL,SERVER,MOUNTSHOST];
         this._layoutInfoArr[TofflistThirdClassMenu.PERSON_CROSS_MOUNTS] = person_cross_mounts;
         var consortia_local_battle:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_local_battle");
         consortia_local_battle.TitleTextString = [RANK,NAME,BATTLE];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_LOCAL_BATTLE] = consortia_local_battle;
         var consortia_local_level:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_local_level");
         consortia_local_level.TitleTextString = [RANK,NAME,LEVEL,ASSET];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_LOCAL_LEVEL] = consortia_local_level;
         var consortia_local_asset:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_local_asset");
         consortia_local_asset.TitleTextString = [RANK,NAME,TOTAL_ASSET];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_LOCAL_ASSET] = consortia_local_asset;
         var consortia_local_charm:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_local_charm");
         consortia_local_charm.TitleTextString = [RANK,NAME,CHARM_VALUE];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_LOCAL_CHARM] = consortia_local_charm;
         var consortia_cross_battle:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_cross_battle");
         consortia_cross_battle.TitleTextString = [RANK,NAME,SERVER,BATTLE];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_CROSS_BATTLE] = consortia_cross_battle;
         var consortia_cross_level:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_cross_level");
         consortia_cross_level.TitleTextString = [RANK,NAME,LEVEL,SERVER,ASSET];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_CROSS_LEVEL] = consortia_cross_level;
         var consortia_cross_asset:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_cross_asset");
         consortia_cross_asset.TitleTextString = [RANK,NAME,SERVER,TOTAL_ASSET];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_CROSS_ASSET] = consortia_cross_asset;
         var consortia_cross_charm:TofflistLayoutInfo = ComponentFactory.Instance.creatCustomObject("consortia_cross_charm");
         consortia_cross_charm.TitleTextString = [RANK,NAME,SERVER,CHARM_VALUE];
         this._layoutInfoArr[TofflistThirdClassMenu.CONSORTIA_CROSS_CHARM] = consortia_cross_charm;
      }
      
      public function get orderList() : TofflistOrderList
      {
         return this._orderList;
      }
      
      public function updateList(list:Array, page:int = 1) : void
      {
         var layoutinfo:TofflistLayoutInfo = null;
         this._orderList.items(list,page);
         if(Boolean(this._id))
         {
            layoutinfo = this._layoutInfoArr[this._id];
            this._orderList.showHline(layoutinfo.TitleHLinePoint);
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(this.parent))
         {
            this.parent.removeChild(this);
         }
      }
      
      public function updateStyleXY($id:String) : void
      {
         var pt:Point = null;
         var i:int = 0;
         var line:Bitmap = null;
         var txt:FilterFrameText = null;
         this._id = $id;
         ObjectUtils.disposeAllChildren(this._title);
         var layoutinfo:TofflistLayoutInfo = this._layoutInfoArr[$id];
         for each(pt in layoutinfo.TitleHLinePoint)
         {
            line = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
            PositionUtils.setPos(line,pt);
            this._title.addChild(line);
         }
         for(i = 0; i < layoutinfo.TitleTextPoint.length; i++)
         {
            txt = ComponentFactory.Instance.creatComponentByStylename("toffilist.listTitleText");
            PositionUtils.setPos(txt,layoutinfo.TitleTextPoint[i]);
            txt.text = layoutinfo.TitleTextString[i];
            this._title.addChild(txt);
         }
      }
   }
}

