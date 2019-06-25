class PostReportMailer < ApplicationMailer
  def post_report(user, post, report)
    @post = post
    @word_count = report.word_count
    @histogram = report.word_histogram
    mail to: user.email, subject: "Post #{post.id} report"
  end
end
