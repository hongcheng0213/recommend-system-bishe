package com.example.recommend.model;

public class TutorScore implements Comparable<TutorScore> {
    private Tutor tutor;
    private double score;
    private String reason;

    public TutorScore(Tutor tutor, double score, String reason) {
        this.tutor = tutor;
        this.score = score;
        this.reason = reason;
    }

    public Tutor getTutor() {
        return tutor;
    }

    public double getScore() {
        return score;
    }

    public String getReason() {
        return reason;
    }

    @Override
    public int compareTo(TutorScore other) {
        return Double.compare(other.score, this.score);
    }
}

