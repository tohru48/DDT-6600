package game.actions
{
   import ddt.command.PlayerAction;
   import ddt.data.BallInfo;
   import ddt.manager.BallManager;
   import ddt.manager.SharedManager;
   import ddt.view.character.GameCharacter;
   import game.GameManager;
   import game.objects.GameLocalPlayer;
   import game.objects.GamePlayer;
   import pet.date.PetSkillTemplateInfo;
   import room.model.RoomInfo;
   
   public class PrepareShootAction extends BaseAction
   {
      
      public static var hasDoSkillAnimation:Boolean;
      
      private var _player:GamePlayer;
      
      private var _actionType:PlayerAction;
      
      private var _hasDonePrepareAction:Boolean;
      
      private var _skill:PetSkillTemplateInfo;
      
      private var _petMovieOver:Boolean = true;
      
      public function PrepareShootAction(player:GamePlayer)
      {
         super();
         this._player = player;
      }
      
      override public function connect(action:BaseAction) : Boolean
      {
         return action is PrepareShootAction;
      }
      
      override public function prepare() : void
      {
         var skill:PetSkillTemplateInfo = null;
         if(Boolean(this._player.player) && this._player.isLiving)
         {
            if(this._player.UsedPetSkill.length > 0 && this._player.UsedPetSkill.list[0].BallType == 1)
            {
               skill = this._player.UsedPetSkill.list[0];
               this._skill = skill;
               this._petMovieOver = false;
               this._player.usePetSkill(skill,this.finishPetMovie);
            }
            else
            {
               this.doPrepareToShootAction();
            }
         }
         else
         {
            _isFinished = true;
         }
      }
      
      private function finishPetMovie() : void
      {
         this.doPrepareToShootAction();
         this._petMovieOver = true;
         this._player.hidePetMovie();
      }
      
      private function doPrepareToShootAction() : void
      {
         this._hasDonePrepareAction = true;
         var ball:BallInfo = BallManager.findBall(this._player.player.currentBomb);
         this._actionType = ball.ActionType == 0 ? GameCharacter.SHOWTHROWS : GameCharacter.SHOWGUN;
         if(GameManager.Instance.Current.roomType != RoomInfo.ACTIVITY_DUNGEON_ROOM || GameManager.Instance.Current.roomType != RoomInfo.STONEEXPLORE_ROOM || this._player is GameLocalPlayer)
         {
            if((this._player.player.skill >= 0 || this._player.player.isSpecialSkill) && SharedManager.Instance.showParticle && !hasDoSkillAnimation)
            {
               hasDoSkillAnimation = true;
               this._player.map.spellKill(this._player);
            }
         }
         this._player.weaponMovie = BallManager.createShootMovieMovie(this._player.player.currentBomb);
         this._player.body.doAction(this._actionType);
         if(Boolean(this._player.weaponMovie))
         {
            this._player.weaponMovie.visible = true;
            this._player.setWeaponMoiveActionSyc("start");
            this._player.body.WingState = GameCharacter.GAME_WING_SHOOT;
         }
      }
      
      override public function execute() : void
      {
         if(!this._petMovieOver)
         {
            return;
         }
         if(this._hasDonePrepareAction && (this._player == null || this._player.body == null || this._player.body.currentAction == null))
         {
            _isFinished = true;
            return;
         }
         if(this._player.body.currentAction != this._actionType)
         {
            if(Boolean(this._player.weaponMovie))
            {
               this._player.weaponMovie.visible = false;
            }
            this._player.body.WingState = GameCharacter.GAME_WING_WAIT;
         }
         if(this._hasDonePrepareAction && (!this._player.map.isPlayingMovie && (!this._player.body.actionPlaying() || this._player.body.currentAction != this._actionType)))
         {
            this._player.isShootPrepared = true;
            _isFinished = true;
         }
      }
   }
}

