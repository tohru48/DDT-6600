// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Messions.CHM1278
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;

#nullable disable
namespace GameServerScript.AI.Messions
{
  public class CHM1278 : AMissionControl
  {
    private SimpleBoss m_king = (SimpleBoss) null;
    private int m_kill = 0;
    private int IsSay = 0;
    private int bossID = 1208;
    private int npcID = 1211;
    private static string[] KillChat = new string[2]
    {
      "灭亡是你唯一的归宿！",
      "太不堪一击了！"
    };
    private static string[] ShootedChat = new string[3]
    {
      "哎哟～你打的我好疼啊！<br/>啊哈哈哈哈！",
      "你们就只有这点本事？！",
      "哼～有点意思了"
    };

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 900)
        return 3;
      if (score > 825)
        return 2;
      return score > 725 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      int[] npcIds = new int[2]{ this.npcID, this.bossID };
      this.Game.LoadResources(npcIds);
      this.Game.LoadNpcGameOverResources(npcIds);
      this.Game.SetMap(1084);
      this.Game.BossCardCount = 1;
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      this.m_king = this.Game.CreateBoss(this.bossID, 890, 590, -1, 0, "");
      this.m_king.FallFrom(890, 590, "fall", 0, 2, 1000);
      this.m_king.SetRelateDemagemRect(-41, -187, 83, 140);
      this.m_king.AddDelay(16);
    }

    public override void OnNewTurnStarted() => base.OnNewTurnStarted();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.IsSay = 0;
    }

    public override bool CanGameOver()
    {
      if (!this.m_king.IsLiving)
      {
        ++this.m_kill;
        return true;
      }
      return this.Game.TurnIndex > this.Game.MissionInfo.TotalTurn - 1;
    }

    public override int UpdateUIData()
    {
      base.UpdateUIData();
      return this.m_kill;
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      bool flag = true;
      foreach (Physics allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving)
          flag = false;
      }
      if (!this.m_king.IsLiving && !flag)
        this.Game.IsWin = true;
      else
        this.Game.IsWin = false;
    }
  }
}
