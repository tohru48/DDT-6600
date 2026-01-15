package consortion.rank
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.event.ConsortionEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RankFrame extends Frame
   {
      
      private static const PRANK:int = 0;
      
      private static const CRANK:int = 1;
      
      private static const BRANK:int = 0;
      
      private static const LRANK:int = 1;
      
      private static const CPAGE:int = 8;
      
      protected static const PPAGE:int = 10;
      
      protected static const LIMITPAGE:int = 1;
      
      protected static var TOTALPAGE:int = 1;
      
      private var _index:int = 1;
      
      protected var _back:Bitmap;
      
      protected var _pRank:SelectedButton;
      
      protected var _cRank:SelectedButton;
      
      private var _group1:SelectedButtonGroup;
      
      private var _group2:SelectedButtonGroup;
      
      protected var _helpBtn:SimpleBitmapButton;
      
      protected var _rightBtn:BaseButton;
      
      protected var _leftBtn:BaseButton;
      
      protected var _pageNum:FilterFrameText;
      
      protected var _totalRank:FilterFrameText;
      
      protected var _totalScroeTxt:FilterFrameText;
      
      protected var _itemContent:Sprite;
      
      protected var _type:int;
      
      protected var _rankList:Array;
      
      protected var _prankBit:Bitmap;
      
      protected var _crankBit:Bitmap;
      
      protected var _pageBack:Scale9CornerImage;
      
      private var _isHave:Boolean;
      
      public function RankFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      protected function initView() : void
      {
         escEnable = true;
         titleText = LanguageMgr.GetTranslation("ddt.consortia.title");
         this._back = ComponentFactory.Instance.creat("asset.consortion.rank.groud");
         addToContent(this._back);
         this._prankBit = ComponentFactory.Instance.creat("consortion.rank.per");
         addToContent(this._prankBit);
         this._crankBit = ComponentFactory.Instance.creat("consortion.rank.cor");
         addToContent(this._crankBit);
         this._crankBit.visible = false;
         this._pRank = ComponentFactory.Instance.creatComponentByStylename("consortion.pseleBtn");
         addToContent(this._pRank);
         this._cRank = ComponentFactory.Instance.creatComponentByStylename("consortion.cseleBtn");
         addToContent(this._cRank);
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.rank.helpBtn");
         addToContent(this._helpBtn);
         this._group1 = new SelectedButtonGroup();
         this._group1.addSelectItem(this._pRank);
         this._group1.addSelectItem(this._cRank);
         this._group1.selectIndex = PRANK;
         this._pageBack = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.upDownTextBgImgAsset");
         addToContent(this._pageBack);
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.rank.nextPageBtn");
         addToContent(this._rightBtn);
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.rank.prePageBtn");
         addToContent(this._leftBtn);
         this._pageNum = ComponentFactory.Instance.creatComponentByStylename("consortion.rank.pageNum");
         this._pageNum.text = "1/1";
         addToContent(this._pageNum);
         this._totalRank = ComponentFactory.Instance.creatComponentByStylename("consortion.rank.totalRank");
         addToContent(this._totalRank);
         this._totalScroeTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.rank.totalScroeTxt");
         addToContent(this._totalScroeTxt);
         this._itemContent = new Sprite();
         this._itemContent.x = 32;
         this._itemContent.y = 130;
         addToContent(this._itemContent);
      }
      
      protected function initItemList(arr:Array) : void
      {
         var i:int = 0;
         var data:RankData = null;
         var item:RankItem = null;
         this.clearItemList();
         var len:int = int(arr.length);
         for(var index:int = 0; i < len; )
         {
            data = arr[i] as RankData;
            this.setRankTxt(data);
            if(data.Rank != -1)
            {
               item = new RankItem(data);
               item.setView(i);
               item.y = (item.height + 1) * index;
               this._itemContent.addChild(item);
               index++;
            }
            i++;
         }
      }
      
      protected function setRankTxt(data:RankData) : void
      {
         if(this._type == CPAGE)
         {
            if(data.ConsortiaID == PlayerManager.Instance.Self.ConsortiaID)
            {
               if(data.Rank != -1)
               {
                  this._totalRank.text = data.Rank.toString();
               }
               else
               {
                  this._totalRank.text = LanguageMgr.GetTranslation("ddt.consortia.norank");
               }
               this._totalScroeTxt.text = data.Score.toString();
            }
         }
         else if(data.UserID == PlayerManager.Instance.Self.ID)
         {
            if(data.Rank != -1)
            {
               this._totalRank.text = data.Rank.toString();
            }
            else
            {
               this._totalRank.text = LanguageMgr.GetTranslation("ddt.consortia.norank");
            }
            this._totalScroeTxt.text = data.Score.toString();
         }
      }
      
      protected function clearItemList() : void
      {
         while(Boolean(this._itemContent.numChildren))
         {
            ObjectUtils.disposeObject(this._itemContent.getChildAt(0));
         }
      }
      
      private function initEvents() : void
      {
         ConsortionModelControl.Instance.addEventListener(ConsortionEvent.CLUB_RANK_LIST,this.clubRankListHander);
         ConsortionModelControl.Instance.addEventListener(ConsortionEvent.PERSONER_RANK_LIST,this.personerRankListHander);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.mouseClickHander);
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.mouseClickHander);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.openHelpViewHander);
         addEventListener(FrameEvent.RESPONSE,this.responseHander);
         this._group1.addEventListener(Event.CHANGE,this.group1changeHandler);
      }
      
      private function removeEvents() : void
      {
         ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.CLUB_RANK_LIST,this.clubRankListHander);
         ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.PERSONER_RANK_LIST,this.personerRankListHander);
         this._rightBtn.removeEventListener(MouseEvent.CLICK,this.mouseClickHander);
         this._leftBtn.removeEventListener(MouseEvent.CLICK,this.mouseClickHander);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.openHelpViewHander);
         this._group1.removeEventListener(Event.CHANGE,this.group1changeHandler);
         removeEventListener(FrameEvent.RESPONSE,this.responseHander);
      }
      
      private function personerRankListHander(e:ConsortionEvent) : void
      {
         this._type = PPAGE;
         var arr:Array = e.data as Array;
         this._rankList = this.setCurrtArr(arr);
         this.setPageTxt(arr);
         this.setPageArr();
      }
      
      private function setCurrtArr(arr:Array) : Array
      {
         for(var i:int = 0; i < arr.length; i++)
         {
            if(arr[i].UserID == PlayerManager.Instance.Self.ID)
            {
               arr.splice(i,1);
               return arr;
            }
         }
         return arr;
      }
      
      private function clubRankListHander(e:ConsortionEvent) : void
      {
         this._type = CPAGE;
         var arr:Array = e.data as Array;
         this._rankList = arr;
         this.setPageTxt(arr);
         this.setPageArr();
      }
      
      protected function setPageTxt(arr:Array) : void
      {
         if(!arr)
         {
            return;
         }
         var num:int = Math.ceil(arr.length / PPAGE);
         if(num == 0)
         {
            num = 1;
         }
         TOTALPAGE = num;
         this._pageNum.text = this._index + "/" + TOTALPAGE;
      }
      
      private function mouseClickHander(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(!this._rankList)
         {
            return;
         }
         switch(e.currentTarget)
         {
            case this._rightBtn:
               ++this._index;
               if(this._index > TOTALPAGE)
               {
                  this._index = 1;
               }
               break;
            case this._leftBtn:
               --this._index;
               if(this._index < LIMITPAGE)
               {
                  this._index = TOTALPAGE;
               }
         }
         this._pageNum.text = this._index + "/" + TOTALPAGE;
         this.setPageArr();
      }
      
      protected function setPageArr() : void
      {
         var i:int = 0;
         var j:int = 0;
         if(!this._rankList)
         {
            return;
         }
         var len:int = int(this._rankList.length);
         var arr:Array = [];
         if(this._type == CPAGE)
         {
            for(i = (this._index - 1) * CPAGE; i < this._index * CPAGE; i++)
            {
               if(Boolean(this._rankList[i]))
               {
                  arr.push(this._rankList[i]);
               }
            }
         }
         else if(this._type == PPAGE)
         {
            for(j = (this._index - 1) * PPAGE; j < this._index * PPAGE; j++)
            {
               if(Boolean(this._rankList[j]))
               {
                  arr.push(this._rankList[j]);
               }
            }
         }
         this.initItemList(arr);
      }
      
      private function openHelpViewHander(e:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         ConsortionModelControl.Instance.openHelpView();
      }
      
      private function responseHander(e:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         this.dispose();
      }
      
      private function group1changeHandler(e:Event) : void
      {
         SoundManager.instance.playButtonSound();
         var type:int = this._group1.selectIndex;
         this._index = 1;
         switch(type)
         {
            case CRANK:
               this._crankBit.visible = true;
               this._prankBit.visible = false;
               ConsortionModelControl.Instance.getConsortionRank();
               break;
            case PRANK:
               this._prankBit.visible = true;
               this._crankBit.visible = false;
               ConsortionModelControl.Instance.getPerRank();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         while(Boolean(numChildren))
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         super.dispose();
      }
   }
}

