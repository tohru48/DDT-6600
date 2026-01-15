// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Game.BossGuild
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;

#nullable disable
namespace GameServerScript.AI.Game
{
  public class BossGuild : APVEGameControl
  {
    public override void OnCreated()
    {
      this.Game.SetupMissions("50001,50002,50003,50004,50005,50006,50007,50008,50009,50010");
      this.Game.TotalMissionCount = 1;
    }

    public override void OnPrepated()
    {
    }

    public override int CalculateScoreGrade(int score)
    {
      if (score > 800)
        return 3;
      if (score > 725)
        return 2;
      return score > 650 ? 1 : 0;
    }

    public override void OnGameOverAllSession()
    {
    }
  }
}
