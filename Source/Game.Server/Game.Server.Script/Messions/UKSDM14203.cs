// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.UKSDM14203
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class UKSDM14203 : AMissionControl
  {
    private PhysicalObj m_kingMoive;
    private PhysicalObj m_kingFront;
    private SimpleBoss m_king = (SimpleBoss) null;
    private SimpleBoss m_secondKing = (SimpleBoss) null;
    private int m_kill = 0;
    private int m_state = 14206;
    private int turn = 0;
    private int IsSay = 0;
    private int firstBossID = 14206;
    private int secondBossID = 14207;
    private int npcID = 14208;
    private int direction;
    private static string[] KillChat = new string[1]
    {
      "O não vocês descontrolaram o espaço e tempo<br>agora todos pagarão pelo erro de vocês!"
    };
    private static string[] ShootedChat = new string[2]
    {
      "Não me ataque, eu apenas ataco vocês para concertar o espaço e tempo do mundo.",
      "Será que eu devo atacar?...não, não posso ter feito os calculos errados!!!"
    };

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 1150)
        return 3;
      if (score > 925)
        return 2;
      return score > 700 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");
      this.Game.LoadResources(new int[3]
      {
        this.firstBossID,
        this.secondBossID,
        this.npcID
      });
      this.Game.LoadNpcGameOverResources(new int[1]
      {
        this.firstBossID
      });
      this.Game.SetMap(11009);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_kingMoive = (PhysicalObj) this.Game.Createlayer(0, 0, "kingmoive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_kingFront = (PhysicalObj) this.Game.Createlayer(720, 495, "font", "game.asset.living.boguoKingAsset", "out", 1, 1);
      this.m_king = this.Game.CreateBoss(this.m_state, 888, 590, -1, 1, "");
      this.m_king.FallFrom(this.m_king.X, 0, "", 0, 2, 2000);
      this.m_king.SetRelateDemagemRect(-21, -87, 72, 59);
      this.m_king.AddDelay(10);
      this.m_king.Say(LanguageMgr.GetTranslation("Como ousam? a guerra se inicia mas tudo tem seu tempo!<br>ao entrarem em confronto comigo, sairá tudo errado, para concertar terei que puni-los com a morte."), 0, 3000);
      this.m_kingMoive.PlayMovie("in", 9000, 0);
      this.m_kingFront.PlayMovie("in", 9000, 0);
      this.m_kingMoive.PlayMovie("out", 13000, 0);
      this.m_kingFront.PlayMovie("out", 13400, 0);
      this.turn = this.Game.TurnIndex;
      this.Game.BossCardCount = 1;
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.Game.TurnIndex <= this.turn + 1)
        return;
      if (this.m_kingMoive != null)
      {
        this.Game.RemovePhysicalObj(this.m_kingMoive, true);
        this.m_kingMoive = (PhysicalObj) null;
      }
      if (this.m_kingFront != null)
      {
        this.Game.RemovePhysicalObj(this.m_kingFront, true);
        this.m_kingFront = (PhysicalObj) null;
      }
    }

    public override bool CanGameOver()
    {
      base.CanGameOver();
      if (!this.m_king.IsLiving && this.m_state == this.firstBossID)
        ++this.m_state;
      if (this.m_state == this.secondBossID && this.m_secondKing == null)
      {
        this.m_secondKing = this.Game.CreateBoss(this.m_state, this.m_king.X, this.m_king.Y, this.m_king.Direction, 1, "");
        this.Game.RemoveLiving(this.m_king.Id);
        if (this.m_secondKing.Direction == 1)
          this.m_secondKing.SetRect(-21, -87, 72, 59);
        this.m_secondKing.SetRelateDemagemRect(-21, -87, 72, 59);
        this.m_secondKing.Say(LanguageMgr.GetTranslation("Como meros humanos chegaram até mim? mesmo assim nunca venceram a guerra e teremos nosso trono de volta, esmagando o <font color='#ff0000'><b>Reino do DDTBrasil</b></font>!"), 0, 3000);
        List<Player> allFightPlayers = this.Game.GetAllFightPlayers();
        Player randomPlayer = this.Game.FindRandomPlayer();
        int num = 0;
        if (randomPlayer != null)
          num = randomPlayer.Delay;
        foreach (Player player in allFightPlayers)
        {
          if (player.Delay < num)
            num = player.Delay;
        }
        this.m_secondKing.AddDelay(num - 2000);
        this.turn = this.Game.TurnIndex;
      }
      if (this.m_secondKing == null || this.m_secondKing.IsLiving)
        return false;
      this.direction = this.m_secondKing.Direction;
      ++this.m_kill;
      return true;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.m_kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.m_state == this.secondBossID && !this.m_secondKing.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
      this.Game.SendLoadResource(new List<LoadingFileInfo>()
      {
        new LoadingFileInfo(2, "image/map/show7.jpg", "")
      });
    }

    public override void DoOther()
    {
      base.DoOther();
      if (this.m_king == null)
        return;
      if (this.m_king.IsLiving)
      {
        int index = this.Game.Random.Next(0, UKSDM14203.KillChat.Length);
        this.m_king.Say(UKSDM14203.KillChat[index], 0, 0);
      }
      else
      {
        int index = this.Game.Random.Next(0, UKSDM14203.KillChat.Length);
        this.m_king.Say(UKSDM14203.KillChat[index], 0, 0);
      }
    }

    public override void OnShooted()
    {
      base.OnShooted();
      if (this.IsSay != 0)
        return;
      if (this.m_king.IsLiving)
      {
        int index = this.Game.Random.Next(0, UKSDM14203.ShootedChat.Length);
        this.m_king.Say(UKSDM14203.ShootedChat[index], 0, 1500);
      }
      else
      {
        int index = this.Game.Random.Next(0, UKSDM14203.ShootedChat.Length);
        this.m_secondKing.Say(UKSDM14203.ShootedChat[index], 0, 1500);
      }
      this.IsSay = 1;
    }
  }
}
