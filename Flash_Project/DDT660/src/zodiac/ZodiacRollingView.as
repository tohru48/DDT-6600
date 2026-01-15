package zodiac
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class ZodiacRollingView extends Sprite implements Disposeable
   {
      
      private var _rollingBtn:MovieClip;
      
      private var btndarkArr:Array;
      
      private var btnShineArr:Array;
      
      private var currentBtn:Image;
      
      private var paopaoArr:Array;
      
      private var finalMovie:MovieClip;
      
      private var _last:int;
      
      private var rollrace:int;
      
      private var rollcount:int;
      
      private var indexpaopao:int;
      
      private var endpaopao:int;
      
      public function ZodiacRollingView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function rolling(index:int) : void
      {
         ZodiacManager.instance.inRolling = true;
         this.endpaopao = index;
         for(var i:int = 0; i < this.paopaoArr.length; i++)
         {
            addChild(this.paopaoArr[i]);
            this.paopaoArr[i].visible = false;
         }
         this.rollrace = 70;
         this.rollcount = 1;
         this.indexpaopao = 0;
         setTimeout(this.startrolling,this.rollrace);
      }
      
      private function startrolling() : void
      {
         var j:int = 0;
         var paopao:MovieClip = this.paopaoArr[this.indexpaopao] as MovieClip;
         paopao.visible = true;
         paopao.gotoAndPlay(1);
         this.indexpaopao = this.indexpaopao == 11 ? 0 : ++this.indexpaopao;
         this.rollcount = this.indexpaopao == 0 ? ++this.rollcount : this.rollcount;
         if(this.rollcount == 2)
         {
            this.rollrace -= 4;
         }
         else if(this.rollcount >= 6)
         {
            this.rollrace += 4;
         }
         if(this.rollcount < 8)
         {
            setTimeout(this.startrolling,this.rollrace);
         }
         else if(this.indexpaopao == this.endpaopao || this.endpaopao == 12 && this.indexpaopao == 0)
         {
            for(j = 0; j < this.paopaoArr.length; j++)
            {
               removeChild(this.paopaoArr[j]);
            }
            this.rollingComplete(this.endpaopao);
         }
         else
         {
            setTimeout(this.startrolling,this.rollrace);
         }
      }
      
      private function rolltest() : void
      {
         for(var i:int = 0; i < this.paopaoArr.length; i++)
         {
            addChild(this.paopaoArr[i]);
            this.paopaoArr[i].visible = false;
         }
         this.rollrace = 70;
         this.rollcount = 1;
         this.indexpaopao = 0;
         setTimeout(this.startrolling,this.rollrace);
      }
      
      private function initView() : void
      {
         var j:int = 0;
         var line:Bitmap = null;
         var di:Bitmap = null;
         var dark:Image = null;
         var mc:MovieClip = null;
         var paopao:MovieClip = null;
         for(var i:int = 1; i <= 12; i++)
         {
            line = ComponentFactory.Instance.creatBitmap("zodiac.rollingview.line");
            addChild(line);
            PositionUtils.setPos(line,"zodiac.rollingview.backline.pos" + i);
            line.rotation = (i - 1) * 30;
            di = ComponentFactory.Instance.creatBitmap("zodiac.rollingview.ball.bg");
            addChild(di);
            PositionUtils.setPos(di,"zodiac.rollingview.ballgb.pos" + i);
         }
         if(this.btndarkArr == null)
         {
            this.btndarkArr = [];
         }
         for(j = 1; j <= 12; j++)
         {
            dark = ComponentFactory.Instance.creatComponentByStylename("zodiac.rollingview.darkbtnball" + j);
            addChild(dark);
            dark.buttonMode = true;
            dark.mouseEnabled = false;
            dark.addEventListener(MouseEvent.CLICK,this.__ballClickHandler);
            PositionUtils.setPos(dark,"zodiac.rollingview.darkbtnball.pos" + j);
            this.btndarkArr.push(dark);
         }
         if(this.btnShineArr == null)
         {
            this.btnShineArr = [];
         }
         for(var k:int = 0; k < 12; k++)
         {
            mc = ClassUtils.CreatInstance("zodiac.rollingview.notcomplete.shine");
            PositionUtils.setPos(mc,"zodiac.rollingview.btnshine.pos" + k);
            this.btnShineArr.push(mc);
         }
         if(this.paopaoArr == null)
         {
            this.paopaoArr = [];
         }
         for(var l:int = 0; l < 12; l++)
         {
            paopao = ClassUtils.CreatInstance("zodiac.rollingview.ball.shine");
            PositionUtils.setPos(paopao,"zodiac.rollingview.paopao.pos" + l);
            this.paopaoArr.push(paopao);
         }
         this.finalMovie = ClassUtils.CreatInstance("zodiac.rollingview.finalstop");
         addChild(this.finalMovie);
         this.hideFinalMovie();
         this._rollingBtn = ClassUtils.CreatInstance("zodiac.rollingview.rolling.btn");
         this._rollingBtn.buttonMode = true;
         this._rollingBtn.mouseEnabled = true;
         PositionUtils.setPos(this._rollingBtn,"zodiac.rollingview.rollingbtn.pos");
         addChild(this._rollingBtn);
         this.update();
         this.refreshBallState();
         this.refreshShineState();
      }
      
      private function initEvent() : void
      {
         this._rollingBtn.addEventListener(MouseEvent.ROLL_OVER,this.__rolloverHandler);
         this._rollingBtn.addEventListener(MouseEvent.ROLL_OUT,this.__outHandler);
         this._rollingBtn.addEventListener(MouseEvent.CLICK,this.__rollingHandler);
      }
      
      private function removeEvent() : void
      {
         this._rollingBtn.removeEventListener(MouseEvent.ROLL_OVER,this.__rolloverHandler);
         this._rollingBtn.removeEventListener(MouseEvent.ROLL_OUT,this.__outHandler);
         this._rollingBtn.removeEventListener(MouseEvent.CLICK,this.__rollingHandler);
      }
      
      private function __rolloverHandler(e:MouseEvent) : void
      {
         this._rollingBtn.gotoAndPlay("move");
      }
      
      private function __outHandler(e:MouseEvent) : void
      {
         this._rollingBtn.gotoAndPlay(1);
      }
      
      private function __rollingHandler(e:MouseEvent) : void
      {
         var frame:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         this._rollingBtn.gotoAndPlay("down");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         if(this._last > 0)
         {
            SocketManager.Instance.out.zodiacRolling();
            this.hideFinalMovie();
            this.removeCurrentPaopao();
         }
         else
         {
            frame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"),LanguageMgr.GetTranslation("zodiac.mainview.addCountstip",ServerConfigManager.instance.zodiacAddPrice),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true,true,LayerManager.ALPHA_BLOCKGOUND,null,"SimpleAlert",60,false,AlertManager.SELECTBTN);
            frame.addEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         }
      }
      
      private function __onAlertResponse(e:FrameEvent) : void
      {
         var frame:BaseAlerFrame = e.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__onAlertResponse);
         if(e.responseCode == FrameEvent.ENTER_CLICK || e.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.Money >= ServerConfigManager.instance.zodiacAddPrice)
            {
               SocketManager.Instance.out.zodiacAddCounts();
            }
            else
            {
               LeavePageManager.showFillFrame();
            }
         }
         frame.dispose();
      }
      
      private function __ballClickHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(ZodiacManager.instance.inRolling)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.inrolling"));
            return;
         }
         var btn:Image = e.currentTarget as Image;
         for(var i:int = 0; i < this.btndarkArr.length; i++)
         {
            if(this.btndarkArr[i] == btn)
            {
               ZodiacManager.instance.setCurrentIndexView(i + 1);
            }
         }
         if(this.finalMovie.visible == true)
         {
            this.refreshBallState();
            this.refreshShineState();
         }
         this.hideFinalMovie();
         this.removeCurrentPaopao();
      }
      
      public function update() : void
      {
         this._last = ZodiacManager.instance.maxCounts - ZodiacManager.instance.finshedCounts;
         if(ZodiacManager.instance.questCounts == 12)
         {
            this._rollingBtn.buttonMode = false;
            this._rollingBtn.mouseEnabled = false;
            this._rollingBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            this._rollingBtn.buttonMode = true;
            this._rollingBtn.mouseEnabled = true;
            this._rollingBtn.filters = [];
         }
         this.refreshShineState();
      }
      
      private function refreshBallState() : void
      {
         var btn:Image = null;
         var qArr:Array = ZodiacManager.instance.questArr;
         for(var i:int = 0; i < qArr.length; i++)
         {
            btn = this.btndarkArr[i] as Image;
            if(qArr[i] != 0)
            {
               btn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               btn.mouseEnabled = true;
            }
            else
            {
               btn.filters = [];
               btn.mouseEnabled = false;
            }
         }
      }
      
      private function refreshShineState() : void
      {
         var qInfo:QuestInfo = null;
         var index:int = 0;
         var qArr:Array = ZodiacManager.instance.questArr;
         for(var i:int = 0; i < qArr.length; i++)
         {
            if(qArr[i] != 0)
            {
               qInfo = TaskManager.instance.getQuestByID(qArr[i]);
               if((ZodiacManager.instance.awardRecord >> i + 1 & 1) == 1)
               {
                  if(Boolean(this.btnShineArr[i].parent))
                  {
                     this.btnShineArr[i].parent.removeChild(this.btnShineArr[i]);
                  }
               }
               else if(qInfo.isAchieved)
               {
                  if(Boolean(this.btnShineArr[i].parent))
                  {
                     this.btnShineArr[i].parent.removeChild(this.btnShineArr[i]);
                  }
               }
               else if(!(this.endpaopao == i + 1 && ZodiacManager.instance.inRolling == true))
               {
                  index = 0;
                  index = this.getChildIndex(this.finalMovie);
                  addChildAt(this.btnShineArr[i],index);
               }
            }
            else if(Boolean(this.btnShineArr[i].parent))
            {
               this.btnShineArr[i].parent.removeChild(this.btnShineArr[i]);
            }
         }
      }
      
      private function hideFinalMovie() : void
      {
         this.finalMovie.visible = false;
      }
      
      private function showFinalMovie(index:int) : void
      {
         PositionUtils.setPos(this.finalMovie,"zodiac.rollingview.finalmc.pos" + index);
         this.finalMovie.rotation = 300 - 30 * index;
         this.finalMovie.visible = true;
         this.finalMovie.gotoAndPlay(1);
      }
      
      private function addCurrentPaopao(index:int) : void
      {
         this.currentBtn = ComponentFactory.Instance.creatComponentByStylename("zodiac.rollingview.lightbtnball" + index);
         var finalindex:int = this.getChildIndex(this.finalMovie);
         addChildAt(this.currentBtn,finalindex);
         PositionUtils.setPos(this.currentBtn,"zodiac.rollingview.darkbtnball.pos" + index);
      }
      
      private function removeCurrentPaopao() : void
      {
         if(this.currentBtn != null)
         {
            removeChild(this.currentBtn);
            this.currentBtn = null;
         }
      }
      
      private function rollingComplete(index:int) : void
      {
         this.removeCurrentPaopao();
         this.addCurrentPaopao(index);
         this.showFinalMovie(index);
         this.refreshBallState();
         this.refreshShineState();
         ZodiacManager.instance.inRolling = false;
         ZodiacManager.instance.setCurrentIndexView(index);
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("zodiac.mainview.rollingcompletemsg"));
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.removeChildAllChildren(this);
      }
   }
}

