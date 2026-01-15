package catchInsect.view
{
   import catchInsect.CatchInsectMananger;
   import catchInsect.componets.CatchInsectRankCell;
   import catchInsect.data.CatchInsectRankInfo;
   import catchInsect.event.CatchInsectEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import road7th.comm.PackageIn;
   
   public class CatchInsectRankView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _titleTxt:FilterFrameText;
      
      private var _vbox:VBox;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _listItem:Vector.<CatchInsectRankCell>;
      
      private var _myRankImg:Bitmap;
      
      private var _txtBg:Scale9CornerImage;
      
      private var _rankTxt:FilterFrameText;
      
      private var _nextDescTxt:FilterFrameText;
      
      private var _needTxt:FilterFrameText;
      
      private var _type:int;
      
      public function CatchInsectRankView(type:int)
      {
         this._type = type;
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("catchInsect.rankBg");
         addChild(this._bg);
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.titleTxt");
         addChild(this._titleTxt);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("catchInsect.indivPrize.vBox2");
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("catchInsect.indivPrize.scrollpanel2");
         this._scrollPanel.setView(this._vbox);
         addChild(this._scrollPanel);
         this._myRankImg = ComponentFactory.Instance.creat("catchInsect.myRank");
         addChild(this._myRankImg);
         this._txtBg = ComponentFactory.Instance.creatComponentByStylename("catchInsect.txtBg");
         PositionUtils.setPos(this._txtBg,"catchInsect.txtBgPos");
         addChild(this._txtBg);
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.rankTxt");
         addChild(this._rankTxt);
         this._rankTxt.text = "10";
         this._nextDescTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.nextDescTxt");
         addChild(this._nextDescTxt);
         this._nextDescTxt.text = LanguageMgr.GetTranslation("catchInsectRankView.nextDescTxt");
         this._needTxt = ComponentFactory.Instance.creatComponentByStylename("catchInsect.nextTxt");
         addChild(this._needTxt);
         this._needTxt.text = "5862";
         switch(this._type)
         {
            case 0:
               this._titleTxt.text = LanguageMgr.GetTranslation("catchInsectRankView.titleTxt");
               break;
            case 1:
               this._titleTxt.text = LanguageMgr.GetTranslation("catchInsectRankView.titleTxt1");
         }
         this._listItem = new Vector.<CatchInsectRankCell>();
      }
      
      private function initEvents() : void
      {
         switch(this._type)
         {
            case 0:
               CatchInsectMananger.instance.addEventListener(CatchInsectEvent.UPDATE_LOCAL_RANK,this.__updateRankInfo);
               CatchInsectMananger.instance.addEventListener(CatchInsectEvent.LOCAL_SELF_INFO,this.__updateSelfInfo);
               break;
            case 1:
               CatchInsectMananger.instance.addEventListener(CatchInsectEvent.UPDATE_AREA_RANK,this.__updateRankInfo);
               CatchInsectMananger.instance.addEventListener(CatchInsectEvent.AREA_SELF_INFO,this.__updateSelfInfo);
         }
      }
      
      protected function __updateSelfInfo(event:CatchInsectEvent) : void
      {
         var pkg:PackageIn = event.pkg;
         var rank:int = pkg.readInt();
         if(rank > 0)
         {
            this._rankTxt.text = rank.toString();
         }
         else
         {
            this._rankTxt.text = LanguageMgr.GetTranslation("bombKing.outOfRank2");
         }
         this._needTxt.text = pkg.readInt().toString();
      }
      
      protected function __updateRankInfo(event:CatchInsectEvent) : void
      {
         var info:CatchInsectRankInfo = null;
         var cell:CatchInsectRankCell = null;
         var arr:Array = null;
         var arr2:Array = null;
         this.clearItems();
         this._listItem = new Vector.<CatchInsectRankCell>();
         var pkg:PackageIn = event.pkg;
         var len:int = pkg.readInt();
         for(var i:int = 0; i <= len - 1; i++)
         {
            info = new CatchInsectRankInfo();
            info.place = pkg.readInt();
            info.score = pkg.readInt();
            info.name = pkg.readUTF();
            info.isVIP = pkg.readBoolean();
            if(this._type == 0)
            {
               arr = ServerConfigManager.instance.catchInsectLocalTitle;
               if(i <= arr.length - 1)
               {
                  info.titleNum = arr[i];
               }
            }
            else
            {
               info.area = pkg.readUTF();
               arr2 = ServerConfigManager.instance.catchInsectAreaTitle;
               if(i <= arr2.length - 1)
               {
                  info.titleNum = arr2[i];
               }
            }
            cell = new CatchInsectRankCell(this._type);
            cell.setData(info);
            this._vbox.addChild(cell);
            this._listItem.push(cell);
         }
         this._scrollPanel.invalidateViewport();
      }
      
      private function clearItems() : void
      {
         this._vbox.removeAllChild();
         for(var i:int = 0; i <= this._listItem.length - 1; i++)
         {
            this._listItem[i].dispose();
            this._listItem[i] = null;
         }
      }
      
      private function removeEvents() : void
      {
         CatchInsectMananger.instance.removeEventListener(CatchInsectEvent.UPDATE_AREA_RANK,this.__updateRankInfo);
         CatchInsectMananger.instance.removeEventListener(CatchInsectEvent.AREA_SELF_INFO,this.__updateSelfInfo);
         CatchInsectMananger.instance.removeEventListener(CatchInsectEvent.UPDATE_LOCAL_RANK,this.__updateRankInfo);
         CatchInsectMananger.instance.removeEventListener(CatchInsectEvent.LOCAL_SELF_INFO,this.__updateSelfInfo);
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         for(var i:int = 0; i <= this._listItem.length - 1; i++)
         {
            ObjectUtils.disposeObject(this._listItem[i]);
            this._listItem[i] = null;
         }
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._vbox);
         this._vbox = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
         ObjectUtils.disposeObject(this._myRankImg);
         this._myRankImg = null;
         ObjectUtils.disposeObject(this._needTxt);
         this._needTxt = null;
         ObjectUtils.disposeObject(this._nextDescTxt);
         this._nextDescTxt = null;
         ObjectUtils.disposeObject(this._rankTxt);
         this._rankTxt = null;
         ObjectUtils.disposeObject(this._scrollPanel);
         this._scrollPanel = null;
         ObjectUtils.disposeObject(this._titleTxt);
         this._titleTxt = null;
         ObjectUtils.disposeObject(this._txtBg);
         this._txtBg = null;
         ObjectUtils.disposeObject(this._vbox);
         this._vbox = null;
      }
   }
}

