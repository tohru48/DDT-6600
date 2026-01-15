package gemstone.items
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import ddt.manager.LanguageMgr;
   import ddt.view.SimpleItem;
   import flash.display.DisplayObject;
   import gemstone.info.GemstoneStaticInfo;
   
   public class GemstoneTip extends BaseTip
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _tempData:Object;
      
      private var _fiSoulName:FilterFrameText;
      
      private var _quality:SimpleItem;
      
      private var _type:SimpleItem;
      
      private var _attack:FilterFrameText;
      
      private var _defense:FilterFrameText;
      
      private var _agility:FilterFrameText;
      
      private var _luck:FilterFrameText;
      
      private var _grade1:FilterFrameText;
      
      private var _grade2:FilterFrameText;
      
      private var _grade3:FilterFrameText;
      
      private var _forever:FilterFrameText;
      
      private var _displayList:Vector.<DisplayObject>;
      
      public function GemstoneTip()
      {
         super();
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
      }
      
      override public function set tipData(data:Object) : void
      {
         this._tempData = data;
         if(!this._tempData)
         {
            return;
         }
         this._displayList = new Vector.<DisplayObject>();
         this.updateView();
      }
      
      private function clear() : void
      {
         var display:DisplayObject = null;
         while(numChildren > 0)
         {
            display = getChildAt(0) as DisplayObject;
            if(Boolean(display.parent))
            {
               display.parent.removeChild(display);
            }
         }
      }
      
      private function updateView() : void
      {
         var gemstonTipItem:GemstonTipItem = null;
         var obj:Object = null;
         this.clear();
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._bg.width = 300;
         this._bg.height = 200;
         this.tipbackgound = this._bg;
         this._fiSoulName = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipItemNameTxt");
         this._displayList.push(this._fiSoulName);
         var temData:Vector.<GemstoneStaticInfo> = this._tempData as Vector.<GemstoneStaticInfo>;
         var len:int = int(temData.length);
         for(var i:int = 0; i < len; i++)
         {
            if(temData[i].attack != 0)
            {
               obj = new Object();
               obj.id = temData[i].id;
               obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstoneAtc",temData[i].level,String(temData[i].attack));
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.redGemstone");
               gemstonTipItem = new GemstonTipItem();
               gemstonTipItem.setInfo(obj);
               this._displayList.push(gemstonTipItem);
            }
            else if(temData[i].defence != 0)
            {
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstone");
               obj = new Object();
               obj.id = temData[i].id;
               obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.bluGemstoneDef",temData[i].level,String(temData[i].defence));
               gemstonTipItem = new GemstonTipItem();
               gemstonTipItem.setInfo(obj);
               this._displayList.push(gemstonTipItem);
            }
            else if(temData[i].agility != 0)
            {
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gesGemstone");
               obj = new Object();
               obj.id = temData[i].id;
               obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.gesGemstoneAgi",temData[i].level,String(temData[i].agility));
               gemstonTipItem = new GemstonTipItem();
               gemstonTipItem.setInfo(obj);
               this._displayList.push(gemstonTipItem);
            }
            else if(temData[i].luck != 0)
            {
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstone");
               obj = new Object();
               obj.id = temData[i].id;
               obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.yelGemstoneLuk",temData[i].level,String(temData[i].luck));
               gemstonTipItem = new GemstonTipItem();
               gemstonTipItem.setInfo(obj);
               this._displayList.push(gemstonTipItem);
            }
            else if(temData[i].blood != 0)
            {
               this._fiSoulName.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstone");
               obj = new Object();
               obj.id = temData[i].id;
               obj.str = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.purpleGemstoneLuk",temData[i].level,String(temData[i].blood));
               gemstonTipItem = new GemstonTipItem();
               gemstonTipItem.setInfo(obj);
               this._displayList.push(gemstonTipItem);
            }
         }
         this.initPos();
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override protected function init() : void
      {
      }
      
      private function initPos() : void
      {
         var i:int = 0;
         var len:int = int(this._displayList.length);
         for(i = 0; i < len; i++)
         {
            this._displayList[i].y = i * 30 + 5;
            this._displayList[i].x = 5;
            addChild(this._displayList[i] as DisplayObject);
         }
      }
   }
}

