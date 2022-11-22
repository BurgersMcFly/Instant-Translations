// InstantTranslations, Cyberpunk 2077 mod that makes translations instant
// Copyright (C) 2022 BurgersMcFly

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

@replaceMethod(SubtitleLineLogicController)
  public func SetLineData(lineData: scnDialogLineData) -> Void {
    let characterRecordID: TweakDBID;
    let displayData: scnDialogDisplayString;
    let isValidName: Bool;
    let motherTongueCtrl: ref<inkTextMotherTongueController>;
    let playerPuppet: ref<gamePuppetBase>;
    let speakerName: String;
    let speakerNameDisplayText: String;
    let speakerNameWidgetStateName: CName;
    this.m_lineData = lineData;
    if IsStringValid(lineData.speakerName) {
      speakerName = lineData.speakerName;
    } else {
      speakerName = lineData.speaker.GetDisplayName();
    };
    isValidName = IsStringValid(speakerName);
    speakerNameDisplayText = isValidName ? "LocKey#76968" : "";
    if isValidName {
      this.m_spekerNameParams.UpdateLocalizedString("NAME", speakerName);
    };
    if IsMultiplayer() {
      speakerNameWidgetStateName = n"Default";
      playerPuppet = lineData.speaker as gamePuppetBase;
      if playerPuppet != null {
        characterRecordID = playerPuppet.GetRecordID();
        speakerNameWidgetStateName = TweakDBInterface.GetCharacterRecord(characterRecordID).CpoClassName();
      };
      inkWidgetRef.SetState(this.m_speakerNameWidget, speakerNameWidgetStateName);
    };
    if Equals(lineData.type, scnDialogLineType.Radio) {
      this.m_targetTextWidgetRef = this.m_radioSubtitle;
      inkTextRef.SetLocalizedTextScript(this.m_radioSpeaker, speakerNameDisplayText, this.m_spekerNameParams);
      inkWidgetRef.SetVisible(this.m_speakerNameWidget, false);
      inkWidgetRef.SetVisible(this.m_subtitleWidget, false);
      inkWidgetRef.SetVisible(this.m_radioSpeaker, true);
      inkWidgetRef.SetVisible(this.m_radioSubtitle, true);
    } else {
      if Equals(lineData.type, scnDialogLineType.AlwaysCinematicNoSpeaker) {
        this.m_targetTextWidgetRef = this.m_radioSubtitle;
        inkWidgetRef.SetVisible(this.m_speakerNameWidget, false);
        inkWidgetRef.SetVisible(this.m_subtitleWidget, false);
        inkWidgetRef.SetVisible(this.m_radioSpeaker, false);
        inkWidgetRef.SetVisible(this.m_radioSubtitle, true);
      } else {
        if Equals(lineData.type, scnDialogLineType.GlobalTVAlwaysVisible) {
          this.m_targetTextWidgetRef = this.m_subtitleWidget;
          inkWidgetRef.SetVisible(this.m_speakerNameWidget, false);
          inkWidgetRef.SetVisible(this.m_subtitleWidget, true);
          inkWidgetRef.SetVisible(this.m_radioSpeaker, false);
          inkWidgetRef.SetVisible(this.m_radioSubtitle, false);
        } else {
          this.m_targetTextWidgetRef = this.m_subtitleWidget;
          inkTextRef.SetLocalizedTextScript(this.m_speakerNameWidget, speakerNameDisplayText, this.m_spekerNameParams);
          inkWidgetRef.SetVisible(this.m_speakerNameWidget, true);
          inkWidgetRef.SetVisible(this.m_subtitleWidget, true);
          inkWidgetRef.SetVisible(this.m_radioSpeaker, false);
          inkWidgetRef.SetVisible(this.m_radioSubtitle, false);
        };
      };
    };
    if scnDialogLineData.HasKiroshiTag(lineData) {
      displayData = scnDialogLineData.GetDisplayText(lineData);
      if this.IsKiroshiEnabled() {
        inkTextRef.SetText(this.m_targetTextWidgetRef, displayData.translation);
      } else {
        motherTongueCtrl = inkWidgetRef.GetControllerByType(this.m_motherTongueContainter, n"inkTextMotherTongueController") as inkTextMotherTongueController;
        motherTongueCtrl.SetPreTranslatedText("");
        motherTongueCtrl.SetNativeText(displayData.text, displayData.language);
        motherTongueCtrl.SetTranslatedText("");
        motherTongueCtrl.SetPostTranslatedText("");
        motherTongueCtrl.ApplyTexts();
      };
    } else {
      if scnDialogLineData.HasMothertongueTag(lineData) {
        displayData = scnDialogLineData.GetDisplayText(lineData);
        motherTongueCtrl = inkWidgetRef.GetControllerByType(this.m_motherTongueContainter, n"inkTextMotherTongueController") as inkTextMotherTongueController;
        motherTongueCtrl.SetPreTranslatedText(displayData.preTranslatedText);
        motherTongueCtrl.SetNativeText(displayData.text, displayData.language);
        motherTongueCtrl.SetTranslatedText(displayData.translation);
        motherTongueCtrl.SetPostTranslatedText(displayData.postTranslatedText);
        motherTongueCtrl.ApplyTexts();
      } else {
        inkTextRef.SetText(this.m_targetTextWidgetRef, this.m_lineData.text);
        this.PlayLibraryAnimation(n"intro");
      };
    };
  }

@replaceMethod(ChatterLineLogicController)
  public func SetLineData(lineData: scnDialogLineData) -> Void {
    let animCtrl: wref<inkTextKiroshiAnimController>;
    let displayData: scnDialogDisplayString;
    let isWide: Bool;
    let motherTongueCtrl: wref<inkTextMotherTongueController>;
    let gameObject: wref<GameObject> = lineData.speaker;
    this.m_isOverHead = Equals(lineData.type, scnDialogLineType.OverHead);
    if IsDefined(gameObject) && gameObject.IsDevice() {
      this.m_rootWidget.SetAnchorPoint(new Vector2(0.50, 0.00));
      this.m_limitSubtitlesDistance = true;
      this.m_subtitlesMaxDistance = 10.00;
      this.m_bubbleMinDistance = 10.00;
    } else {
      if IsDefined(gameObject) && this.m_isOverHead {
        this.m_rootWidget.SetAnchorPoint(new Vector2(0.50, 1.00));
        this.m_limitSubtitlesDistance = true;
        this.m_subtitlesMaxDistance = 30.00;
        this.m_bubbleMinDistance = 25.00;
      } else {
        this.m_rootWidget.SetAnchorPoint(new Vector2(0.50, 1.00));
        this.m_limitSubtitlesDistance = false;
        this.m_subtitlesMaxDistance = 0.00;
        this.m_bubbleMinDistance = 0.00;
      };
    };
    this.m_projection.SetEntity(lineData.speaker);
    displayData = scnDialogLineData.GetDisplayText(lineData);
    isWide = StrLen(displayData.translation) >= this.c_ExtraWideTextWidth;
    this.m_ownerId = lineData.speaker.GetEntityID();
    if isWide {
      animCtrl = this.m_kiroshiAnimationCtrl_Wide;
      motherTongueCtrl = this.m_motherTongueCtrl_Wide;
    } else {
      animCtrl = this.m_kiroshiAnimationCtrl_Normal;
      motherTongueCtrl = this.m_motherTongueCtrl_Normal;
    };
    inkWidgetRef.SetVisible(this.m_text_normal, !isWide);
    inkWidgetRef.SetVisible(this.m_text_wide, isWide);
    inkWidgetRef.SetVisible(this.m_container_normal, !isWide);
    inkWidgetRef.SetVisible(this.m_container_wide, isWide);
    inkWidgetRef.SetVisible(this.m_TextContainer, false);
    inkWidgetRef.SetVisible(this.m_speachBubble, true);
    if scnDialogLineData.HasKiroshiTag(lineData) {
      displayData = scnDialogLineData.GetDisplayText(lineData);
      if this.IsKiroshiEnabled() {
        inkTextRef.SetText(this.m_text_normal, displayData.translation);
        inkTextRef.SetText(this.m_text_wide, displayData.translation);
      } else {
        motherTongueCtrl.SetPreTranslatedText("");
        motherTongueCtrl.SetNativeText(displayData.text, displayData.language);
        motherTongueCtrl.SetTranslatedText("");
        motherTongueCtrl.SetPostTranslatedText("");
        motherTongueCtrl.ApplyTexts();
      };
    } else {
      if scnDialogLineData.HasMothertongueTag(lineData) {
        displayData = scnDialogLineData.GetDisplayText(lineData);
        motherTongueCtrl.SetPreTranslatedText(displayData.preTranslatedText);
        motherTongueCtrl.SetNativeText(displayData.text, displayData.language);
        motherTongueCtrl.SetTranslatedText(displayData.translation);
        motherTongueCtrl.SetPostTranslatedText(displayData.postTranslatedText);
        motherTongueCtrl.ApplyTexts();
      } else {
        inkTextRef.SetText(this.m_text_normal, lineData.text);
        inkTextRef.SetText(this.m_text_wide, lineData.text);
      };
    };
  }
