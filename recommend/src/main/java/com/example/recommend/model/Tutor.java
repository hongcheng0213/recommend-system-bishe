package com.example.recommend.model;

public class Tutor {
    private int id;
    private String name;
    private String gender;
    private String university;
    private String department;
    private String researchFields;
    private Integer quota;
    private String title;
    private String researchAchievement;
    private int studentQuota;
    private String photo;
    private String homepageUrl;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getResearchFields() {
        return researchFields;
    }

    public void setResearchFields(String researchFields) {
        this.researchFields = researchFields;
    }

    public Integer getQuota() {
        return quota;
    }

    public void setQuota(Integer quota) {
        this.quota = quota;
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

    public String getUniversity() {
        return university;
    }

    public void setUniversity(String university) {
        this.university = university;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String getHomepageUrl() {
        return homepageUrl;
    }

    public void setHomepageUrl(String homepageUrl) {
        this.homepageUrl = homepageUrl;
    }
}
