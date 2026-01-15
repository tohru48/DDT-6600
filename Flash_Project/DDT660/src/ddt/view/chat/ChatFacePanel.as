package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ChatFacePanel extends ChatBasePanel
   {
      
      private static const MAX_FACE_CNT:uint = 49;
      
      private static const COLUMN_LENGTH:uint = 10;
      
      private static const FACE_SPAN:uint = 25;
      
      protected var _bg:Bitmap;
      
      private var _faceBtns:Vector.<BaseButton> = new Vector.<BaseButton>();
      
      private var _inGame:Boolean;
      
      private var _selected:int;
      
      public function ChatFacePanel(inGame:Boolean = false)
      {
         super();
         this._inGame = inGame;
      }
      
      public function dispose() : void
      {
         var btn:BaseButton = null;
         removeChild(this._bg);
         for each(btn in this._faceBtns)
         {
            btn.dispose();
         }
         this._faceBtns = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      public function get selected() : int
      {
         return this._selected;
      }
      
      private function __itemClick(evt:MouseEvent) : void
      {
         var str:String = (evt.target as BaseButton).backStyle;
         SoundManager.instance.play("008");
         this._selected = int(str.slice(str.length - 2));
         dispatchEvent(new Event(Event.SELECT));
      }
      
      protected function createBg() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.chat.FacePanelBg");
         addChild(this._bg);
      }
      
      override protected function init() : void
      {
         var _facePos:Point = null;
         var rowIdx:uint = 0;
         var colIdx:uint = 0;
         var bt:BaseButton = null;
         super.init();
         this.createBg();
         _facePos = ComponentFactory.Instance.creatCustomObject("chat.FacePanelFacePos");
         rowIdx = 0;
         colIdx = 0;
         var disabledList:Array = PathManager.solveChatFaceDisabledList();
         for(var i:int = 1; i < MAX_FACE_CNT; i++)
         {
            if(!(Boolean(disabledList) && disabledList.indexOf(String(i)) > -1))
            {
               if(colIdx == COLUMN_LENGTH)
               {
                  colIdx = 0;
                  rowIdx++;
               }
               bt = new BaseButton();
               bt.beginChanges();
               bt.backStyle = "asset.chat.FaceBtn_" + (i < 10 ? "0" + String(i) : String(i));
               bt.tipStyle = "core.ChatFaceTips";
               bt.tipDirctions = "4";
               bt.tipGapV = 5;
               bt.tipGapH = -5;
               bt.tipData = LanguageMgr.GetTranslation("tank.view.chat.ChatFacePannel.face" + String(i));
               bt.commitChanges();
               bt.x = colIdx * FACE_SPAN + _facePos.x;
               bt.y = rowIdx * FACE_SPAN + _facePos.y;
               bt.addEventListener(MouseEvent.CLICK,this.__itemClick);
               this._faceBtns.push(bt);
               addChild(bt);
               colIdx++;
            }
         }
      }
   }
}

