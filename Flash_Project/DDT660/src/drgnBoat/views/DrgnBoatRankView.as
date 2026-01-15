package drgnBoat.views
{
   import com.greensock.TweenLite;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import drgnBoat.DrgnBoatManager;
   import drgnBoat.event.DrgnBoatEvent;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class DrgnBoatRankView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _moveInBtn:SimpleBitmapButton;
      
      private var _moveOutBtn:SimpleBitmapButton;
      
      private var _rankTxt:FilterFrameText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _rateTxt:FilterFrameText;
      
      private var _rankCellList:Vector.<DrgnBoatRankCell>;
      
      public function DrgnBoatRankView()
      {
         super();
         this.x = 756;
         this.y = -3;
         this.initView();
         this.initEvent();
         this.setInOutVisible(true);
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var tmpCell:DrgnBoatRankCell = null;
         this._bg = ComponentFactory.Instance.creatBitmap("drgnBoat.rankViewBg");
         this._moveOutBtn = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.rankViewMoveOutBtn");
         this._moveInBtn = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.rankViewMoveInBtn");
         this._rankTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.rankView.titleTxt");
         this._rankTxt.text = LanguageMgr.GetTranslation("escort.rankView.rankTitleTxt");
         this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.rankView.titleTxt");
         this._nameTxt.text = LanguageMgr.GetTranslation("escort.rankView.nameTitleTxt");
         PositionUtils.setPos(this._nameTxt,"drgnBoat.rankView.nameTitleTxtPos");
         this._rateTxt = ComponentFactory.Instance.creatComponentByStylename("drgnBoat.rankView.titleTxt");
         this._rateTxt.text = LanguageMgr.GetTranslation("drgnBoat.rankView.rateTitleTxt");
         PositionUtils.setPos(this._rateTxt,"drgnBoat.rankView.rateTitleTxtPos");
         addChild(this._bg);
         addChild(this._moveOutBtn);
         addChild(this._moveInBtn);
         addChild(this._rankTxt);
         addChild(this._nameTxt);
         addChild(this._rateTxt);
         this._rankCellList = new Vector.<DrgnBoatRankCell>();
         for(i = 0; i < 5; i++)
         {
            tmpCell = new DrgnBoatRankCell(i);
            tmpCell.x = 17;
            tmpCell.y = 63 + i * 28;
            addChild(tmpCell);
            this._rankCellList.push(tmpCell);
         }
      }
      
      private function initEvent() : void
      {
         this._moveOutBtn.addEventListener(MouseEvent.CLICK,this.outHandler,false,0,true);
         this._moveInBtn.addEventListener(MouseEvent.CLICK,this.inHandler,false,0,true);
         DrgnBoatManager.instance.addEventListener(DrgnBoatManager.RANK_LIST,this.refreshRankList);
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setInOutVisible(false);
         TweenLite.to(this,0.5,{"x":1000});
      }
      
      private function setInOutVisible(isOut:Boolean) : void
      {
         this._moveOutBtn.visible = isOut;
         this._moveInBtn.visible = !isOut;
      }
      
      private function inHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.setInOutVisible(true);
         TweenLite.to(this,0.5,{"x":756});
      }
      
      private function refreshRankList(event:DrgnBoatEvent) : void
      {
         var rankInfoList:Array = event.data as Array;
         var len:int = int(rankInfoList.length);
         for(var i:int = 0; i < len; i++)
         {
            this._rankCellList[i].setName(rankInfoList[i].name,rankInfoList[i].carType,rankInfoList[i].isSelf);
         }
      }
      
      private function removeEvent() : void
      {
         this._moveOutBtn.removeEventListener(MouseEvent.CLICK,this.outHandler);
         this._moveInBtn.removeEventListener(MouseEvent.CLICK,this.inHandler);
         DrgnBoatManager.instance.removeEventListener(DrgnBoatManager.RANK_LIST,this.refreshRankList);
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._moveInBtn = null;
         this._moveOutBtn = null;
         this._rankTxt = null;
         this._nameTxt = null;
         this._rateTxt = null;
         this._rankCellList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

