package cryptBoss.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.ListItemEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ComboBox;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.controls.list.VectorListModel;
   import cryptBoss.CryptBossManager;
   import cryptBoss.data.CryptBossItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class CryptBossSetFrame extends Frame
   {
      
      private var _data:CryptBossItemInfo;
      
      private var _bossIcon:Bitmap;
      
      private var _itemBg:Bitmap;
      
      private var _levelBg:Bitmap;
      
      private var _fightBtn:SimpleBitmapButton;
      
      private var _levelComboBox:ComboBox;
      
      private var _levelArr:Array;
      
      private var _cellVec:Vector.<BaseCell>;
      
      private var _list:SimpleTileList;
      
      private var _scrollPanel:ScrollPanel;
      
      private var _level:int;
      
      public function CryptBossSetFrame(data:CryptBossItemInfo)
      {
         super();
         this._data = data;
         this._levelArr = LanguageMgr.GetTranslation("cryptBoss.setFrame.levelTxt").split(",");
         this._cellVec = new Vector.<BaseCell>();
         this._level = this._data.star == 5 ? this._data.star : this._data.star + 1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("cryptBoss.setFrame.titleTxt");
         this._bossIcon = ComponentFactory.Instance.creat("asset.cryptBoss.boss" + this._data.id);
         PositionUtils.setPos(this._bossIcon,"cryptBoss.setFrame.bossPos");
         addToContent(this._bossIcon);
         this._itemBg = ComponentFactory.Instance.creat("asset.cryptBoss.itemBg");
         addToContent(this._itemBg);
         this._levelBg = ComponentFactory.Instance.creat("asset.cryptBoss.levelSelect");
         addToContent(this._levelBg);
         this._levelComboBox = ComponentFactory.Instance.creatComponentByStylename("cryptBoss.levelChooseComboBox");
         addToContent(this._levelComboBox);
         this._fightBtn = ComponentFactory.Instance.creatComponentByStylename("cryptBoss.fightBtn");
         addToContent(this._fightBtn);
         this._fightBtn.enable = this._data.state == 1;
         this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("cryptBoss.setFrame.dropListPanel");
         this._scrollPanel.vScrollProxy = ScrollPanel.AUTO;
         this._scrollPanel.hScrollProxy = ScrollPanel.OFF;
         addToContent(this._scrollPanel);
         this._list = new SimpleTileList(5);
         this._list.hSpace = 4;
         this._list.vSpace = 5;
         this.updateLevelComboBox();
         this.updateItems();
      }
      
      private function updateItems() : void
      {
         var id:int = 0;
         var cell:BaseCell = null;
         var item:ItemTemplateInfo = null;
         var cell1:BaseCell = null;
         while(this._cellVec.length > 0)
         {
            cell = this._cellVec.shift();
            cell.dispose();
         }
         var idArr:Array = CryptBossManager.instance.getTemplateIdArr(50200 + this._data.id,this._level);
         var rect:Rectangle = ComponentFactory.Instance.creatCustomObject("cryptBoss.setFrame.cellRect");
         for each(id in idArr)
         {
            item = ItemManager.Instance.getTemplateById(id);
            cell1 = new BaseCell(ComponentFactory.Instance.creatBitmap("cryptBoss.dropCellBgAsset"),item);
            cell1.setContentSize(rect.width,rect.height);
            cell1.PicPos = new Point(rect.x,rect.y);
            this._list.addChild(cell1);
            this._cellVec.push(cell1);
         }
         this._scrollPanel.setView(this._list);
         this._scrollPanel.invalidateViewport();
      }
      
      private function updateLevelComboBox() : void
      {
         this._levelComboBox.beginChanges();
         this._levelComboBox.selctedPropName = "text";
         var comboxModel:VectorListModel = this._levelComboBox.listPanel.vectorListModel;
         comboxModel.clear();
         var i:int = 0;
         while(i < this._data.star + 1 && i < this._levelArr.length)
         {
            comboxModel.append(this._levelArr[i]);
            i++;
         }
         this._levelComboBox.listPanel.list.updateListView();
         this._levelComboBox.commitChanges();
         this._levelComboBox.textField.text = this._levelArr[this._level - 1];
      }
      
      private function __itemClick(event:ListItemEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._level == event.index + 1)
         {
            return;
         }
         this._level = event.index + 1;
         this.updateItems();
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._levelComboBox.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._levelComboBox.button.addEventListener(MouseEvent.CLICK,this.__buttonClick);
         this._fightBtn.addEventListener(MouseEvent.CLICK,this.__fightHandler);
      }
      
      protected function __fightHandler(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.Grade < 31)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.functionLimitTip",31));
            return;
         }
         SocketManager.Instance.out.sendCryptBossFight(this._data.id,this._level);
      }
      
      private function __buttonClick(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      protected function __responseHandler(evt:FrameEvent) : void
      {
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._levelComboBox.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK,this.__itemClick);
         this._levelComboBox.button.removeEventListener(MouseEvent.CLICK,this.__buttonClick);
         this._fightBtn.removeEventListener(MouseEvent.CLICK,this.__fightHandler);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         super.dispose();
         this._bossIcon = null;
         this._itemBg = null;
         this._levelBg = null;
         this._fightBtn = null;
         this._levelComboBox = null;
         this._list = null;
         this._scrollPanel = null;
         this._cellVec = null;
      }
   }
}

