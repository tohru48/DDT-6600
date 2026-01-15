package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.VBox;
   import ddt.data.EquipType;
   import ddt.manager.PathManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ChatChannelPanel extends ChatBasePanel
   {
      
      private var _bg:Bitmap;
      
      private var _channelBtns:Vector.<BaseButton> = new Vector.<BaseButton>();
      
      private var _vbox:VBox;
      
      private var _currentChannel:Object = new Object();
      
      private const chanelMap:Array = [15,0,1,2,3,4,5];
      
      public function ChatChannelPanel()
      {
         super();
      }
      
      private function __itemClickHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new ChatEvent(ChatEvent.INPUT_CHANNEL_CHANNGED,this._currentChannel[(e.target as BaseButton).backStyle]));
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creatBitmap("asset.chat.ChannelPannelBg");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("chat.channelPanel.vbox");
         if(Boolean(ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_CBUGLE)) && PathManager.solveCrossBuggleEable())
         {
            this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_CrossBuggleBtn"));
         }
         if(Boolean(ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_BBUGLE)))
         {
            this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_BigBuggleBtn"));
         }
         if(Boolean(ShopManager.Instance.getMoneyShopItemByTemplateID(EquipType.T_SBUGLE)))
         {
            this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_SmallBuggleBtn"));
         }
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_PrivateBtn"));
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_ConsortiaBtn"));
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_TeamBtn"));
         this._channelBtns.push(ComponentFactory.Instance.creat("chat.ChannelState_CurrentBtn"));
         addChild(this._bg);
         addChild(this._vbox);
         for(var i:uint = 0; i < this._channelBtns.length; i++)
         {
            this._channelBtns[i].addEventListener(MouseEvent.CLICK,this.__itemClickHandler);
            this._currentChannel[this._channelBtns[i].backStyle] = this.chanelMap[7 - this._channelBtns.length + i];
            this._vbox.addChild(this._channelBtns[i]);
         }
         this._bg.height = 18 * this._channelBtns.length + 10;
      }
      
      public function get btnLen() : int
      {
         return this._channelBtns.length;
      }
   }
}

