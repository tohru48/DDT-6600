package trainer.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   public class SecondOnlineView extends BaseAlerFrame
   {
      
      private var _bmpBg:ScaleBitmapImage;
      
      private var _bmpNpc:Bitmap;
      
      private var _tile:SimpleTileList;
      
      private var _conent1:FilterFrameText;
      
      private var _conent2:FilterFrameText;
      
      private var _conent3:FilterFrameText;
      
      public function SecondOnlineView()
      {
         super();
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this.initView();
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         ObjectUtils.disposeAllChildren(this);
         this._tile.dispose();
         this._bmpBg = null;
         this._bmpNpc = null;
         this._tile = null;
         this._conent1 = null;
         this._conent2 = null;
         this._conent3 = null;
         super.dispose();
      }
      
      private function initView() : void
      {
         var pos:Point = null;
         var outBg:Bitmap = null;
         var cell:BaseCell = null;
         info = new AlertInfo();
         _info.showCancel = false;
         _info.moveEnable = false;
         _info.autoButtonGape = false;
         _info.submitLabel = LanguageMgr.GetTranslation("ok");
         _info.customPos = ComponentFactory.Instance.creatCustomObject("trainer.second.posBtn");
         this._bmpBg = ComponentFactory.Instance.creatComponentByStylename("trainer.view.SecondOnlineView.bg");
         addToContent(this._bmpBg);
         this._conent1 = ComponentFactory.Instance.creatComponentByStylename("trainer.view.SecondOnlineView.conentText1");
         this._conent1.text = LanguageMgr.GetTranslation("trainer.view.SecondOnlineView.conentText1.text");
         addToContent(this._conent1);
         this._conent2 = ComponentFactory.Instance.creatComponentByStylename("trainer.view.SecondOnlineView.conentText2");
         this._conent2.text = LanguageMgr.GetTranslation("trainer.view.SecondOnlineView.conentText2.text");
         addToContent(this._conent2);
         this._conent3 = ComponentFactory.Instance.creatComponentByStylename("trainer.view.SecondOnlineView.conentText3");
         this._conent3.text = LanguageMgr.GetTranslation("trainer.view.SecondOnlineView.conentText3.text");
         addToContent(this._conent3);
         this._bmpNpc = ComponentFactory.Instance.creat("asset.trainer.welcome.girl2");
         PositionUtils.setPos(this._bmpNpc,"trainer.second.posGirl");
         addToContent(this._bmpNpc);
         pos = ComponentFactory.Instance.creatCustomObject("trainer.posSecondTile");
         var id:Array = [9003,8003,112097,11998,11901,11233];
         this._tile = new SimpleTileList(3);
         this._tile.hSpace = 2;
         this._tile.vSpace = 2;
         this._tile.x = pos.x;
         this._tile.y = pos.y;
         for(var i:int = 0; i < id.length; i++)
         {
            outBg = ComponentFactory.Instance.creatBitmap("asset.ddtcore.goods.cellBg");
            cell = new BaseCell(outBg,ItemManager.Instance.getTemplateById(id[i]),true,true);
            this._tile.addChild(cell);
         }
         addToContent(this._tile);
         ChatManager.Instance.releaseFocus();
      }
      
      private function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
   }
}

