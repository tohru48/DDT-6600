// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.UKSHM14304
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class UKSHM14304 : AMissionControl
  {
    private SimpleBoss boss = (SimpleBoss) null;
    private int bossID = 14309;
    private int IsSay = 0;
    private int kill = 0;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;
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
      int[] npcIds1 = new int[1]{ this.bossID };
      int[] npcIds2 = new int[1]{ this.bossID };
      this.Game.LoadResources(npcIds1);
      this.Game.LoadNpcGameOverResources(npcIds2);
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      this.Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.AntQueenAsset");
      this.Game.SetMap(11029);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_moive = (PhysicalObj) this.Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 1);
      this.m_front = (PhysicalObj) this.Game.Createlayer(1131, 150, "font", "game.asset.living.AntQueenAsset", "out", 1, 1);
      this.boss = this.Game.CreateBoss(this.bossID, 1316, 444, -1, 1, "");
      this.boss.SetRelateDemagemRect(-80, -165, 100, 187);
      this.boss.Say(LanguageMgr.GetTranslation("Vocês conheceram a era dos fantasmas, preparem-se, por que acho que vocês ão iram gostar nem um pouco!"), 0, 3000);
      this.m_moive.PlayMovie("in", 9000, 0);
      this.m_front.PlayMovie("in", 9000, 0);
      this.m_moive.PlayMovie("out", 13000, 0);
      this.m_front.PlayMovie("out", 13400, 0);
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      if (this.Game.TurnIndex <= 1)
        return;
      if (this.m_moive != null)
      {
        this.Game.RemovePhysicalObj(this.m_moive, true);
        this.m_moive = (PhysicalObj) null;
      }
      if (this.m_front != null)
      {
        this.Game.RemovePhysicalObj(this.m_front, true);
        this.m_front = (PhysicalObj) null;
      }
    }

    public override bool CanGameOver()
    {
      if (this.boss == null || this.boss.IsLiving)
        return false;
      ++this.kill;
      return true;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (this.boss != null && !this.boss.IsLiving)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }

    public override void DoOther()
    {
      base.DoOther();
      this.Game.Random.Next(0, UKSHM14304.KillChat.Length);
    }

    public override void OnShooted()
    {
      if (!this.boss.IsLiving || this.IsSay != 0)
        return;
      int index = this.Game.Random.Next(0, UKSHM14304.ShootedChat.Length);
      this.boss.Say(UKSHM14304.ShootedChat[index], 0, 1500);
      this.IsSay = 1;
    }
  }
}
