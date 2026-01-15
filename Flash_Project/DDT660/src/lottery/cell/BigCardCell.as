package lottery.cell
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class BigCardCell extends SmallCardCell
   {
      
      private var _bg:Bitmap;
      
      private var _nameField:FilterFrameText;
      
      private var _shading:Bitmap;
      
      private var _isShowName:Boolean = true;
      
      public function BigCardCell()
      {
         super();
      }
      
      public function get isShowName() : Boolean
      {
         return this._isShowName;
      }
      
      public function set isShowName(value:Boolean) : void
      {
         this._isShowName = value;
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._nameField = ComponentFactory.Instance.creatComponentByStylename("lottery.lotteryCardCell.nameField");
         addChild(this._nameField);
         _selectedBg.setFrame(2);
         ShowTipManager.Instance.removeTip(this);
         addEventListener(MouseEvent.CLICK,this.__cellClick);
      }
      
      override protected function updateSize() : void
      {
         var size:Rectangle = null;
         size = ComponentFactory.Instance.creatCustomObject("lottery.cardCell.picBigSize");
         _pic.width = size.width;
         _pic.height = size.height;
         size = ComponentFactory.Instance.creatCustomObject("lottery.cardCell.selectedBigSize");
         _selectedBg.width = size.width;
         _selectedBg.height = size.height;
         _selectedBg.x = size.x;
         _selectedBg.y = size.y;
      }
      
      override public function set cardId(value:int) : void
      {
         super.cardId = value;
         this._nameField.text = String(_tipData);
         this._nameField.visible = this.isShowName;
      }
      
      private function __cellClick(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      override public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__cellClick);
         if(Boolean(this._nameField))
         {
            ObjectUtils.disposeObject(this._nameField);
         }
         this._nameField = null;
         super.dispose();
      }
   }
}

