// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.Game.RunRunChickenSimpleGame
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;

#nullable disable
namespace GameServerScript.AI.Game
{
  internal class RunRunChickenSimpleGame : APVEGameControl
  {
    public override void OnCreated()
    {
      this.Game.SetupMissions("7001,7002,7003,7004");
      this.Game.TotalMissionCount = 4;
    }

    public override void OnPrepated() => base.OnPrepated();

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 900)
        return 3;
      if (score > 825)
        return 2;
      return score > 725 ? 1 : 0;
    }

    public override void OnGameOverAllSession() => base.OnGameOverAllSession();
  }
}
