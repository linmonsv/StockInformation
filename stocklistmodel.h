#ifndef STOCKLISTMODEL_H
#define STOCKLISTMODEL_H
#include <QAbstractListModel>
class StockListModelPrivate;
class StockListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource)
public:
    StockListModel(QObject *parent = 0);
    ~StockListModel();
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;
    QString source() const;
    void setSource(const QString& filePath);
    Q_INVOKABLE QString errorString() const;
    Q_INVOKABLE bool hasError() const;
    Q_INVOKABLE void reload();
    Q_INVOKABLE void remove(int index);
private:
    StockListModelPrivate *m_dptr;
};

#endif // STOCKLISTMODEL_H
