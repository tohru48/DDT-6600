package treasurePuzzle.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextField;
   import treasurePuzzle.controller.TreasurePuzzleManager;
   import treasurePuzzle.data.TreasurePuzzlePiceData;
   import treasurePuzzle.data.TreasurePuzzleRewardData;
   
   public class TreasurePuzzleHelpView extends Frame
   {
      
      private var _view:Sprite;
      
      private var _bg:ScaleBitmapImage;
      
      private var _topBg:Bitmap;
      
      private var _downBg:Bitmap;
      
      private var _panel:ScrollPanel;
      
      private var _panel2:ScrollPanel;
      
      private var _vbox:VBox;
      
      public function TreasurePuzzleHelpView()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this._view = new Sprite();
         titleText = LanguageMgr.GetTranslation("treasurePuzzle.view.helpTitle");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.frameBg");
         this._view.addChild(this._bg);
         this._topBg = ComponentFactory.Instance.creat("treasurePuzzle.treasurePuzzletopBg");
         this._downBg = ComponentFactory.Instance.creat("treasurePuzzle.treasurePuzzledownBg");
         this._view.addChild(this._topBg);
         this._view.addChild(this._downBg);
         this._panel = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.helpPanel");
         this._view.addChild(this._panel);
         this._panel2 = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.helpPanel2");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.Vbox");
         this._view.addChild(this._panel2);
         addToContent(this._view);
         this.createRewardContent();
         this.createContent();
         enterEnable = true;
         escEnable = true;
      }
      
      private function createRewardContent() : void
      {
         var titleNum:int = int(TreasurePuzzleManager.Instance.model.dataArr.length);
         this.setRewardInfo(titleNum);
      }
      
      private function setRewardInfo(type:int) : void
      {
         var data:TreasurePuzzlePiceData = null;
         var isShiwu:Boolean = false;
         var rewardList:Array = null;
         var j:int = 0;
         var rewardData:TreasurePuzzleRewardData = null;
         var id:int = 0;
         var num:int = 0;
         var itemName:String = null;
         var treasureItem:TreasurePuzzleHelpContentItem = null;
         var title1:String = LanguageMgr.GetTranslation("treasurePUzzle.view.helpContentSJ") + LanguageMgr.GetTranslation("treasurePuzzle.view.helpContentTitleRed") + LanguageMgr.GetTranslation("treasurePUzzle.view.helpContentGet");
         var title2:String = LanguageMgr.GetTranslation("treasurePUzzle.view.helpContentSJ") + LanguageMgr.GetTranslation("treasurePuzzle.view.helpContentTitleBlue") + LanguageMgr.GetTranslation("treasurePUzzle.view.helpContentGet");
         var title3:String = LanguageMgr.GetTranslation("treasurePUzzle.view.helpContentSJ") + LanguageMgr.GetTranslation("treasurePuzzle.view.helpContentTitleYellow") + LanguageMgr.GetTranslation("treasurePUzzle.view.helpContentGet");
         var titleArr:Array = [title1,title2,title3];
         var str:String = "";
         for(var i:int = 0; i < TreasurePuzzleManager.Instance.model.dataArr.length; i++)
         {
            data = TreasurePuzzleManager.Instance.model.dataArr[i];
            isShiwu = data.isShiwu;
            if(isShiwu)
            {
               str += LanguageMgr.GetTranslation("treasurePuzzle.view.shiwuContent");
            }
            else
            {
               rewardList = data.rewardList;
               for(j = 0; j < rewardList.length; j++)
               {
                  rewardData = rewardList[j];
                  id = rewardData.rewardId;
                  num = rewardData.rewardNum;
                  itemName = ItemManager.Instance.getTemplateById(id).Name;
                  if(j == 0)
                  {
                     str += itemName + "x" + num;
                  }
                  else
                  {
                     str += "、" + itemName + "x" + num;
                  }
               }
            }
            str += "/";
         }
         var strArr:Array = str.split("/");
         strArr.splice(-1,1);
         for(var k:int = 0; k < strArr.length; k++)
         {
            treasureItem = new TreasurePuzzleHelpContentItem(k,titleArr[k],strArr[k]);
            this._vbox.addChild(treasureItem);
         }
         var sp:Sprite = new Sprite();
         var txt:TextField = new TextField();
         txt.height = 50;
         txt.text = "111";
         sp.alpha = 0;
         sp.addChild(txt);
         this._vbox.addChild(sp);
         this._panel2.setView(this._vbox);
      }
      
      private function createContent() : void
      {
         var content:Sprite = new Sprite();
         var title:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.contentTitle");
         title.text = LanguageMgr.GetTranslation("treasurePuzzle.view.helpContentTitle");
         content.addChild(title);
         var contentText:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("treasurePuzzle.helpView.contentText");
         contentText.text = LanguageMgr.GetTranslation("treasurePuzzle.view.helpContentText");
         content.addChild(contentText);
         this._panel.setView(content);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _response(e:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(e.responseCode == FrameEvent.CLOSE_CLICK || e.responseCode == FrameEvent.ESC_CLICK || e.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.close();
         }
      }
      
      private function close() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
         ObjectUtils.disposeObject(this._view);
         ObjectUtils.disposeObject(this);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this._response);
         if(Boolean(this._bg))
         {
            this._bg.dispose();
            this._bg = null;
         }
         if(Boolean(this._view))
         {
            ObjectUtils.disposeObject(this._view);
            this._view = null;
         }
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

