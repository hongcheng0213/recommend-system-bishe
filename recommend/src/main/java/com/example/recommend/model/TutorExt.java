package com.example.recommend.model;

public class TutorExt {
    private int tutorId;
    private String title;
    private String researchAchievement;
    private int studentQuota;

    public int getTutorId() {
        return tutorId;
    }

    public void setTutorId(int tutorId) {
        this.tutorId = tutorId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getResearchAchievement() {
        return researchAchievement;
    }

    public void setResearchAchievement(String researchAchievement) {
        this.researchAchievement = researchAchievement;
    }

    public int getStudentQuota() {
        return studentQuota;
    }

    public void setStudentQuota(int studentQuota) {
        this.studentQuota = studentQuota;
    }
}
